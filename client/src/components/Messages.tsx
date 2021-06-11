import React from 'react';
import { Empty } from 'google-protobuf/google/protobuf/empty_pb';
import { useState, useEffect } from 'react';
import { MessengerClient } from '../messenger/MessengerServiceClientPb';
import { MessageResponse } from '../messenger/messenger_pb';
import { ClientReadableStream } from 'grpc-web';
import { Timestamp } from 'google-protobuf/google/protobuf/timestamp_pb';
import { chat } from '../types/chat';

type Props = {
  messengerClient: MessengerClient;
};

const Messages: React.FC<Props> = ({ messengerClient }) => {
  const [chatMessages, setChatMessages] = useState<chat.chatMessage[]>([]);

  useEffect(() => {
    // $ at the end of variable has no special sytax meaning
    // But in convention, it's used to indicate the variable is Observable.
    const stream$ = messengerClient.fetchMessage(
      new Empty(),
    ) as ClientReadableStream<MessageResponse>;

    stream$.on('data', res => {
      console.log({
        action: 'gettting stream data',
        response: res,
      });
      setChatMessages(state => [
        {
          message: res.getMessage(),
          timestamp: res.getTimestamp() as Timestamp,
        },
        ...state,
      ]); // To reverse the order
    });

    stream$.on('status', status => {
      console.log({
        action: 'gettting stream status',
        code: status.code,
        detail: status.details,
        metadata: status.metadata,
      });
    });

    stream$.on('end', () => console.log('Stream finished.'));
  }, [messengerClient]);

  return (
    <div className="ui relaxed divided list">
      {chatMessages.map(m => {
        const msg = m.message;
        const ts = m.timestamp;

        return (
          <div className="item" key={m.timestamp.toString()}>
            <i className="user large middle aligned icon" />
            <div className="content">
              <div className="header">{msg}</div>
              <div className="description">{ts.toDate().toLocaleString()}</div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default Messages;

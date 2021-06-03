import React from 'react';
import { Empty } from 'google-protobuf/google/protobuf/empty_pb';
import { useState, useEffect } from 'react';
import { MessengerClient } from '../messenger/MessengerServiceClientPb';
import { MessageResponse } from '../messenger/messenger_pb';
import { ClientReadableStream } from 'grpc-web';

export const useMessages = (
  client: MessengerClient,
): { messages: string[] } => {
  const [messages, setMessages] = useState<string[]>([]);

  useEffect(() => {
    // $ at the end of variable has no special sytax meaning
    // But in convention, it's used to indicate the variable is Observable.
    const stream$ = client.fetchMessage(
      new Empty(),
    ) as ClientReadableStream<MessageResponse>;
    stream$.on('data', res => {
      console.log('Getting response.');
      console.log(res);
      setMessages(state => [...state, res.getMessage()]);
    });
    stream$.on('status', status => {
      console.log(status.code);
      console.log(status.details);
      console.log(status.metadata);
    });
    stream$.on('end', () => console.log('Finished'));
  }, [client]);

  return {
    messages,
  };
};

type Props = {
  messages: string[];
};

const Messages: React.FC<Props> = ({ messages }) => {
  return (
    <div className="ui relaxed divided list">
      {messages.map(m => {
        const [msg, time] = m.split(': ');

        return (
          <div className="item" key={m}>
            <i className="user large middle aligned icon" />
            <div className="content">
              <div className="header">{msg}</div>
              <div className="description">{time}</div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default Messages;

import React from 'react';
import { MessageRequest } from '../messenger/messenger_pb';
import { useState, useCallback, SyntheticEvent } from 'react';
import { MessengerClient } from '../messenger/MessengerServiceClientPb';

// type Props = ReturnType<typeof useMessageForm>;
type Props = {
  messengerClient: MessengerClient;
};

const MessageForm: React.FC<Props> = ({ messengerClient }) => {
  const [message, setMessage] = useState<string>('');

  // Input Message
  const onChange = useCallback(
    (event: SyntheticEvent) => {
      const target = event.target as HTMLInputElement;
      setMessage(target.value);
    },
    [setMessage],
  );

  // Post Message
  const onSubmit = useCallback(
    (event: SyntheticEvent) => {
      event.preventDefault();
      const req = new MessageRequest();
      req.setMessage(message);
      messengerClient.postMessage(req, null, res => console.log(res));
      setMessage('');
    },
    [messengerClient, message],
  );

  return (
    <form className="ui form" onSubmit={onSubmit}>
      <div className="ui field">
        <label>{"What's up to you?"}</label>
        <input type="text" value={message} onChange={onChange} />
      </div>
      <button className="ui button primary" type="submit">
        Post
      </button>
    </form>
  );
};

export default MessageForm;

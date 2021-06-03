import React from 'react';
import { MessageRequest } from '../messenger/messenger_pb';
import { useState, useCallback, SyntheticEvent } from 'react';
import { MessengerClient } from '../messenger/MessengerServiceClientPb';

type useMessageFormProps = {
  message: string;
  onChange: (event: SyntheticEvent) => void;
  onSubmit: (event: SyntheticEvent) => void;
};

export const useMessageForm = (
  client: MessengerClient,
): useMessageFormProps => {
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
      client.postMessage(req, null, res => console.log(res));
      setMessage('');
    },
    [client, message],
  );

  return {
    message,
    onChange,
    onSubmit,
  };
};

type Props = ReturnType<typeof useMessageForm>;

const MessageForm: React.FC<Props> = ({ message, onChange, onSubmit }) => {
  return (
    <form className="ui form" onSubmit={onSubmit}>
      <div className="ui field">
        <label>{"What's up to you?"}</label>
        <input type="text" value={message} onChange={onChange} />
        <button className="ui button primary" type="submit">
          Post
        </button>
      </div>
    </form>
  );
};

export default MessageForm;

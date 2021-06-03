import React from 'react';
import Messages, { useMessages } from './Messages';
import MessageForm, { useMessageForm } from './MessageForm';
import { gRPCClients } from '../gRPCclient';

const App: React.FC = () => {
  const messagesState = useMessages(gRPCClients.messengerClient);
  const messageFormState = useMessageForm(gRPCClients.messengerClient);

  return (
    <div className="container ui">
      <br />
      <h1 className="ui header aligned center">Chat App with gRPC</h1>
      <div className="ui container">
        <MessageForm {...messageFormState} />
      </div>
      <br />
      <div className="ui container">
        <Messages {...messagesState} />
      </div>
    </div>
  );
};

export default App;

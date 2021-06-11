import React from 'react';
import Messages from './Messages';
import MessageForm from './MessageForm';
import { gRPCClients } from '../gRPCclient';

const App: React.FC = () => {
  return (
    <div className="container ui">
      <br />
      <h1 className="ui header aligned center">Chat App with gRPC</h1>
      <div className="ui container">
        <MessageForm messengerClient={gRPCClients.messengerClient} />
      </div>
      <br />
      <div className="ui container">
        <Messages messengerClient={gRPCClients.messengerClient} />
      </div>
    </div>
  );
};

export default App;

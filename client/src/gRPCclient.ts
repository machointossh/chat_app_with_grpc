import { MessengerClient } from './messenger/MessengerServiceClientPb';

export type GRPCClients = {
  messengerClient: MessengerClient;
};

export const gRPCClients = {
  // messengerClient: new MessengerClient(`http://10.107.70.75:80`),
  messengerClient: new MessengerClient(
    `http://${process.env.REACT_APP_SERVER_HOSTNAME}`,
  ),
  // You need 'http://' and ':<PORT>' even if it is 80.
};

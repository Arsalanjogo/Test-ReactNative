import React from 'react';
import {MessageBar, MessageBarManager} from 'react-native-message-bar';
import {Metrics} from '../../Theme';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.msg_bar = React.createRef();
  }
  componentDidMount() {
    MessageBarManager.registerMessageBar(this.msg_bar.current);
  }

  componentWillUnmount() {
    MessageBarManager.unregisterMessageBar();
  }

  render() {
    return (
      <MessageBar
        ref={this.msg_bar}
        viewTopInset={Metrics.MESSAGE_BAR_HEIGHT}
      />
    );
  }
}

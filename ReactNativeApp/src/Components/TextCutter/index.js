import React, {Component} from 'react';
import {Text, View} from 'react-native';
// import Icon from 'react-native-vector-icons/MaterialIcons';
// import { ThemeColor } from '../assets/Colors/Colors';
import {Colors} from '../../Theme';
export default class TextCutter extends Component {
  state = {
    showCompleteText: false,
  };

  _showText = completeText => {
    if (this.state.showCompleteText === true) {
      return completeText;
    } else {
      return `${completeText.slice(0, this.props.limit)}`;
    }
  };
  componentDidMount() {
    // console.log(this.props.text.length, this.props.limit)
    if (this.props.text.length < this.props.limit) {
      this.setState({showCompleteText: true});
    } else {
      this.setState({showCompleteText: false});
    }
  }
  render() {
    return (
      <View style={{width: '90%'}}>
        <Text
          style={this.props.style}
          onPress={() => {
            if (!this.state.showCompleteText)
              this.setState(function (prevState) {
                return {showCompleteText: !prevState.showCompleteText};
              });
          }}>
          {this._showText(this.props.text)}
          {this.state.showCompleteText ? null : (
            <Text
              style={{
                borderWidth: 1,
                fontWeight: 'bold',
                color: Colors.primary,
              }}>
              ... More
            </Text>
          )}
        </Text>
      </View>
    );
  }
}

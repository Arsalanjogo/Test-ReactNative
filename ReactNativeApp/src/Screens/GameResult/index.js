import React from 'react';
import {View, Text} from 'react-native';
import {Button, CustomText, Header, RootView} from '../../Components';
import {Navigator} from '../../Utils';
import styles from './styles';

export default function GameResult() {
  return (
    <RootView>
      <Header showLeftIcon={false} />
      <View style={styles.container}>
        <View style={styles.infoContainer}>
          <CustomText bold style={styles.title}>
            Juggling Master
          </CustomText>
          <View style={styles.videoContainer}></View>
          <CustomText bold style={styles.heading}>
            Your Score
          </CustomText>
          <CustomText style={styles.score}>123 Juggles</CustomText>
          <View style={styles.awardsView}>
            <CustomText style={styles.awardText}>3X Multiplier</CustomText>
            <CustomText style={styles.awardText}>3X Bonus</CustomText>
          </View>
        </View>
        <View style={styles.buttonContainer}>
          <Button
            title="Back to Exercises"
            secondary
            style={styles.button}
            onPress={() => Navigator.navigate('Games')}
          />
          <Button title="Play Again" />
        </View>
      </View>
    </RootView>
  );
}

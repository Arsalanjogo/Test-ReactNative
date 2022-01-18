import {FlatList, Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {CustomText, Header, RootView} from '../../Components';
import GamesCard from '../../Components/GamesCard';
import { Metrics } from '../../Theme';

const data = [1,2,3,4,5,6]

const Games = () => {
  const [value, setValue] = useState('');

  return (
    <RootView bottom={0}>
      <Header search={true}/>
      <FlatList 
      style={{flex:1,paddingHorizontal:Metrics.defaultMargin,paddingTop:Metrics.defaultMargin}}
      data={data}
      key={Math.random()}
      renderItem={({item})=><GamesCard/>}
      />
      
    </RootView>
  );
};

export default Games;

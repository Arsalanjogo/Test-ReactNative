import React, {useImperativeHandle, useState} from 'react';
import {LoaderView} from '../../Components';

const TopLoader = (props, forwardedRef) => {
  //set default state
  const [isVisibale, setIsVisible] = useState(false);

  // hide modal function
  const hideMoadl = () => {
    setIsVisible(false);
  };

  // show and hide functions for ref
  useImperativeHandle(forwardedRef, () => ({
    show: () => {
      setIsVisible(true);
    },
    hide: () => {
      hideMoadl();
    },
  }));

  if (isVisibale) {
    return <LoaderView />;
  }
  return null;
};
export default React.forwardRef(TopLoader);

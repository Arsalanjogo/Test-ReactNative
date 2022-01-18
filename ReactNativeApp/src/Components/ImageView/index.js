import React, { useEffect, useState } from 'react';
import FastImage from 'react-native-fast-image';
import { ActivityIndicator, Image, View } from 'react-native';
import { Colors, Metrics } from '../../Theme';

const w = Metrics.width;
const h = Metrics.width;

export const ImageView = ({
    style,
    imageUrl,
    children,
    resizeMode,
    localImage,
    originalSize = false,
    setImageSize = () => { }
}) => {
    // console.log(style, "style")
    const [width, setWidth] = useState(0);
    const [height, setHeight] = useState(0);
    const [loading, setLoading] = useState(false);
    let noImage =
        'https://jogobucket.s3.eu-west-2.amazonaws.com/media/placeholder/placeholder.png';
    let image = imageUrl ? imageUrl : noImage;

    useEffect(() => {
        if (originalSize && image) {
            Image.getSize(
                image,
                (width, height) => {
                    setWidth(w);
                    setHeight(Math.ceil(height * Metrics.width) / width);
                    setImageSize({ height: Math.ceil(height * Metrics.width) / width })
                },
                () => {
                    setWidth(w);
                    setHeight(w);
                    setImageSize({ height: h })
                },
            );
        }
    }, []);

    if (width == 0 && originalSize) {
        return (
            <View
                style={{
                    width: w,
                    height: h,
                    backgroundColor: Colors.lightBackground,
                    alignItems: 'center',
                    justifyContent: 'center',
                    borderRadius: 10,
                }}>
                <ActivityIndicator size="large" />
            </View>
        );
    } else
        return (
            <FastImage
                style={[originalSize ? { width: width, height: height } : {}, style]}
                resizeMode={!resizeMode ? FastImage.resizeMode.contain : resizeMode}
                onLoadStart={() => setLoading(true)}
                onLoadEnd={() => setLoading(false)}
                source={
                    localImage
                        ? localImage
                        : { uri: image, priority: FastImage.priority.normal }
                }>
                {children}
                {/* {loading && <ActivityIndicator
                    animating
                    size="large"
                    color={Colors.backgroundDark}
                    style={{
                        position: 'absolute',
                        top: 150,
                        left: 70,
                        right: 70,
                        height: 50,
                    }}
                />} */}
            </FastImage>
        );
};
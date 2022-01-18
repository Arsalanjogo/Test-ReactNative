import React from 'react'
import { View, Text, Pressable, TouchableWithoutFeedback } from 'react-native'
import { Colors, Fonts, Metrics } from '../../../Theme'
import styles from '../TextInput/styles'

export default function CustomText({
    children,
    bold = false,
    style,
    containerStyle,
    ...props
}) {

    return (
        <View style={containerStyle}>
            <Text style={{
                color: Colors.textLight,
                fontFamily: bold ? Fonts.primaryBold : Fonts.primary,
                fontSize: bold ? Metrics.largeFont : Metrics.defaultFont,
                ...style
            }}
                {...props}
            >{children}</Text>

        </View>
    )
}

import { StyleSheet } from 'react-native';
import { Colors, Fonts, Metrics } from '../../Theme';

const styles = StyleSheet.create({
    container: {
        marginLeft: Metrics.defaultMargin,
        // marginRight: Metrics.largeMargin,

    },
    outerContainer: {
        flexDirection: "row",
        justifyContent: "space-between",

    },
    iconContainer: {
        flexDirection: "row",
        paddingRight: Metrics.defaultMargin
    },

    icon: {
        fontSize: Metrics.largeFont * 2.0,

    },

    textStyle: {
        marginBottom: Metrics.smallMargin * 0.5,
        // fontSize: Metrics.defaultFont,
        fontWeight: "700",
        fontSize: 12,
        lineHeight: 16
    },
    detailedStyle: {
        color: Colors.textLight,
        fontFamily: Fonts.primary,
        fontSize: Metrics.defaultFont,
    },
    captionFont: {
        color: Colors.light,
        fontSize: 12,
        lineHeight: 16,
        fontWeight: "400",
    },
    timeStyle: {
        fontSize: 12,
        lineHeight: 16,
        fontWeight: "400",
    },
    commentTextStyle: {
        fontFamily: Fonts.primaryMedium,
        color: Colors.textDisabled,
        fontSize: 12,
        lineHeight: 16,
        fontWeight: "700",
        marginVertical: Metrics.smallMargin * 0.5
    },
    textInput: {
        width: '70%',
        height: '100%',
        fontSize: Metrics.defaultFont,
        color: Colors.placeholder
    },
    moreText: {
        color: Colors.primary,
        fontSize: Metrics.smallFont,
        flex: 1
        // position: "absolute",
        // bottom: 0,
        // right: -40
    }
});

export default styles;
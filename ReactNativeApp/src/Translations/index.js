import * as RNLocalize from 'react-native-localize';
import i18n from 'i18n-js';
import memoize from 'lodash.memoize';
import AsyncStorage from '@react-native-community/async-storage';
import { I18nManager } from 'react-native';
import {setLanguageTag} from '../Utils/Helpers'

import en from './english.json';
import nl from './dutch.json';

const translationGetters = {
    en,
    nl
};

const translate = memoize(
    (key, config) => i18n.t(key, config),
    (key, config) => (config ? key + JSON.stringify(config) : key)
);

export default translate;

export const setI18nConfig = async () => {
    // Get user selected language from storage
    const lang = await AsyncStorage.getItem('langTag')

    //Fallback if no language is set
    const fallback = { languageTag: 'en', isRTL: false };

    const { languageTag, isRTL } = RNLocalize.findBestAvailableLanguage(Object.keys(translationGetters)) || fallback;
    setLanguageTag(lang || languageTag)
    // clear translation cache
    translate.cache.clear();
    // update layout direction
    I18nManager.forceRTL(isRTL);
    // set i18n-js config
    i18n.translations = { [lang || languageTag]: translationGetters[lang || languageTag] };
    i18n.locale = lang || languageTag;
};

import {Text, View, ScrollView} from 'react-native';
import React, {useEffect, useState} from 'react';
import {RootView, CustomText, Header} from '../../Components';
import styles from './styles';

const TermsAndConditions = () => {
  const [value, setValue] = useState('');

  return (
    <RootView>
      <Header showRightIcon={false} title={'Terms & Condition'} />
      <ScrollView style={styles.container}>
        <CustomText style={styles.title}>Terms {`&`} Conditions</CustomText>
        <CustomText style={styles.details}>
          This is a mock condition...We agree to provide you with the Instagram
          Service. The Service includes all of the Instagram products, features,
          applications, services, technologies and software that we provide to
          advance Instagram's mission: To bring you closer to the people and
          things you love. The Service is made up of the following aspects:
          Offering personalised opportunities to create, connect, communicate,
          discover and share. People are different. We want to strengthen your
          relationships through shared experiences that you actually care about.
          So we build systems that try to understand who and what you and others
          care about, and use that information to help you create, find, join
          and share in experiences that matter to you. Part of that is
          highlighting content, features, offers and accounts that you might be
          interested in, and offering ways for you to experience Instagram,
          based on things that you and others do on and off Instagram. Fostering
          a positive, inclusive and safe environment. We develop and use tools
          and offer resources to our community members that help to make their
          experiences positive and inclusive, including when we think they might
          need help. We also have teams and systems that work to combat abuse
          and breaches of our Terms and Policies, as well as harmful and
          deceptive behaviour. We use all the information we have – including
          your information – to try to keep our platform secure. We may also
          share information about misuse or harmful content with other Facebook
          Companies or law enforcement. Learn more in the Data Policy.
          Developing and using technologies that help us consistently serve our
          growing community. Organising and analysing information for our
          growing community is central to our Service. A big part of our Service
          is creating and using cutting-edge technologies that help us
          personalise, protect and improve our Service on an incredibly large
          scale for a broad global community. Technologies such as artificial
          intelligence and machine learning give us the power to apply complex
          processes across our Service. Automated technologies also help us to
          ensure the functionality and integrity of our Service. Providing
          consistent and seamless experiences across other Facebook Company
          Products. Instagram is part of the Facebook Companies, which share
          technology, systems, insights, and information – including the
          information we have about you (learn more in the Data Policy) – in
          order to provide services that are better, safer and more secure. We
          also provide ways to interact across the Facebook Company Products
          that you use, and have designed systems to achieve a seamless and
          consistent experience across the Facebook Company Products. Ensuring
          access to our Service. To operate our global Service, we must store
          and transfer data across our systems around the world, including
          outside of your country of residence. The use of this global
          infrastructure is necessary and essential to provide our Service. This
          infrastructure may be owned or operated by Facebook Inc., Facebook
          Ireland Limited, or their affiliates. Connecting you with brands,
          products and services in ways you care about. We use data from
          Instagram and other Facebook Company Products, as well as from
          third-party partners, to show you ads, offers and other sponsored
          content that we believe will be meaningful to you. And we try to make
          that content as relevant as all your other experiences on Instagram.
          Research and innovation. We use the information we have to study our
          Service and collaborate with others on research to make our Service
          better and contribute to the well-being of our community.
        </CustomText>
      </ScrollView>
    </RootView>
  );
};

export default TermsAndConditions;

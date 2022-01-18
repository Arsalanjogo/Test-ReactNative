import {Util} from '../../Utils';

export const getUserToken = store => store.auth?.data?.user?.access_Token ?? '';

export const getUser = store => store.auth?.data?.user ?? '';

export const isUserLogin = store =>
  store.auth.data.user ? !Util.isEmpty(store.auth.data.user) : false;

export const getUserID = store => store.auth?.data?.user?.id ?? undefined;

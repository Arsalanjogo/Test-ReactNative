const defaultList = [];

export const getPosts = store => store?.home?.posts ?? defaultList;

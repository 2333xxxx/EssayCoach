import { request } from "../request";

/**
 * Login
 *
 * @param userName User name
 * @param password Password
 */
export function fetchLogin(userName: string, password: string) {
  // return request<Api.Auth.LoginToken>({
  //   url: '/auth/login',
  //   method: 'post',
  //   data: {
  //     userName,
  //     password
  //   }
  // });
  return Promise.resolve({
    data: {
      token: "token-test",
      refreshToken: "refreshToken-test",
    },
    error: false,
  });
}

/** Get user info */
export function fetchGetUserInfo() {
  // return request<Api.Auth.UserInfo>({ url: "/auth/getUserInfo" });
  return Promise.resolve({
    data: {
      userId: "userId-test",
      userName: "userName-test",
      roles: ["roles-test"],
      buttons: ["buttons-test"],
    },
    error: false,
  });
}

/**
 * Refresh token
 *
 * @param refreshToken Refresh token
 */
export function fetchRefreshToken(refreshToken: string) {
  // return request<Api.Auth.LoginToken>({
  //   url: "/auth/refreshToken",
  //   method: "post",
  //   data: {
  //     refreshToken,
  //   },
  // });
  return Promise.resolve({
    data: {
      token: "token-test",
      refreshToken: "refreshToken-test",
    },
    error: false,
  });
}

/**
 * return custom backend error
 *
 * @param code error code
 * @param msg error message
 */
export function fetchCustomBackendError(code: string, msg: string) {
  return request({ url: "/auth/error", params: { code, msg } });
}

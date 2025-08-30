import { error } from "node:console";
import { request } from "../request";

// hard code mock data type
const mockMenuRoute: Api.Route.MenuRoute[] = [
  {
    id: "1",
    name: "test",
    path: "/test",
    component: "component-test",
    children: [],
  },
];
// hard code mock data type
const mockUserRoute: Api.Route.UserRoute = {
  routes: mockMenuRoute,
  home: "404",
};

/** get constant routes */
export function fetchGetConstantRoutes() {
  // return request<Api.Route.MenuRoute[]>({ url: '/route/getConstantRoutes' });
  return Promise.resolve({
    data: mockMenuRoute,
    error: false,
  });
}

/** get user routes */
export function fetchGetUserRoutes() {
  // return request<Api.Route.UserRoute>({ url: "/route/getUserRoutes" });
  return Promise.resolve({
    data: mockUserRoute,
    error: false,
  });
}

/**
 * whether the route is exist
 *
 * @param routeName route name
 */
export function fetchIsRouteExist(routeName: string) {
  // return request<boolean>({
  //   url: "/route/isRouteExist",
  //   params: { routeName },
  // });
  return Promise.resolve({
    data: true,
  });
}

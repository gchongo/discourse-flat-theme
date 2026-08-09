import { setDefaultHomepage } from "discourse/lib/utilities";

export default {
  name: "flat-theme-default-homepage",
  after: "url-redirects",

  initialize(owner) {
    const currentUser = owner.lookup("service:current-user");
    const homepageId = currentUser?.user_option?.homepage_id;

    // Theme default is /latest. Keep an explicit user homepage preference.
    if (homepageId == null || homepageId === -1) {
      setDefaultHomepage("latest");
    }
  },
};

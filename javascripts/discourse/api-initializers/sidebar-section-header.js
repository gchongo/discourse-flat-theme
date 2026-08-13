import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.modifyClass(
    "component:sidebar/user/categories-section",
    (Superclass) =>
      class extends Superclass {
        get headerActionsIcon() {
          return this.headerActions.length > 1 ? "wrench" : "pencil";
        }
      }
  );
});

import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  // Always minimize the home logo when topic info is docked in the header,
  // so a wide logo image cannot reserve a large empty gap before the title.
  api.registerValueTransformer?.(
    "home-logo-minimized",
    ({ value, context }) => {
      if (context?.topicInfoVisible) {
        return true;
      }
      return value;
    }
  );
});

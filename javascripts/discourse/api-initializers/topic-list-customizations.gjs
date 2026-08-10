import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.registerValueTransformer(
    "create-topic-label",
    ({ value, context }) =>
      value || (context.site.desktopView ? value : context.defaultKey)
  );

  if (settings.show_topic_excerpts) {
    api.registerValueTransformer("topic-list-item-expand-pinned", () => true);
  }
});

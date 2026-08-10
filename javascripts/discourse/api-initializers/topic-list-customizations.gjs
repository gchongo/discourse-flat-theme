import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.registerValueTransformer(
    "create-topic-label",
    ({ value, context }) =>
      value || (context.site.desktopView ? value : context.defaultKey)
  );

  api.registerValueTransformer(
    "topic-list-item-expand-pinned",
    () => settings.show_topic_excerpts
  );
});

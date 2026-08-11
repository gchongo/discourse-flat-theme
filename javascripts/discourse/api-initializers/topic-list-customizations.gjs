import { apiInitializer } from "discourse/lib/api";
import HeaderPostersCell from "discourse/components/topic-list/header/posters-cell";
import ItemPostersCell from "discourse/components/topic-list/item/posters-cell";

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

  // Suggested topics omit @showPosters for public topics; add the column so
  // author + reply avatars match the homepage topic list.
  api.registerValueTransformer(
    "topic-list-columns",
    ({ value: columns, context }) => {
      if (context?.listContext === "suggested" && !columns.has?.("posters")) {
        columns.add(
          "posters",
          {
            header: HeaderPostersCell,
            item: ItemPostersCell,
          },
          { after: "topic", before: "replies" }
        );
      }
      return columns;
    }
  );
});

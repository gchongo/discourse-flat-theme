import { apiInitializer } from "discourse/lib/api";
import BlockHero from "../blocks/block-hero";

export default apiInitializer((api) => {
  api.renderBlocks("main-outlet-blocks", [
    {
      block: BlockHero,
      id: "hero",
      conditions: [
        { type: "route", pages: ["HOMEPAGE", "TOP_MENU"] },
        { not: { type: "route", urls: ["/categories"] } },
        { type: "setting", source: settings, name: "show_hero", enabled: true },
      ],
    },
  ]);
});

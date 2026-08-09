import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockRailContributors from "../blocks/block-rail-contributors";
import BlockRailEvents from "../blocks/block-rail-events";
import BlockRailHotTopics from "../blocks/block-rail-hot-topics";
import BlockRailOnline from "../blocks/block-rail-online";
import BlockRailTags from "../blocks/block-rail-tags";

export default apiInitializer((api) => {
  api.renderBlocks("sidebar-discovery", [
    {
      block: BlockGroup,
      id: "info-rail",
      conditions: [
        { type: "route", pages: ["HOMEPAGE", "TOP_MENU"] },
        { not: { type: "route", urls: ["/categories"] } },
        {
          type: "setting",
          source: settings,
          name: "show_info_rail",
          enabled: true,
        },
        { type: "viewport", min: "lg" },
      ],
      children: [
        { block: BlockRailEvents },
        { block: BlockRailHotTopics },
        {
          block: BlockRailContributors,
          args: {
            leaderboardId: settings.rail_leaderboard_id ?? 1,
          },
        },
        { block: BlockRailTags },
        { block: BlockRailOnline },
      ],
    },
  ]);
});

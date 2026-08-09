import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockRailContributors from "../blocks/block-rail-contributors";
import BlockRailEvents from "../blocks/block-rail-events";
import BlockRailHotTopics from "../blocks/block-rail-hot-topics";
import BlockRailLinks from "../blocks/block-rail-links";
import BlockRailOnline from "../blocks/block-rail-online";
import BlockRailStats from "../blocks/block-rail-stats";
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
        {
          block: BlockRailContributors,
          args: {
            leaderboardId: settings.rail_leaderboard_id ?? 1,
          },
        },
        { block: BlockRailHotTopics },
        { block: BlockRailOnline },
        { block: BlockRailStats },
        { block: BlockRailTags },
        {
          block: BlockRailLinks,
          args: {
            links: settings.rail_links,
          },
        },
      ],
    },
  ]);
});

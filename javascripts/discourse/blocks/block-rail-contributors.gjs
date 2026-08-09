import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import dBoundAvatarTemplate from "discourse/ui-kit/helpers/d-bound-avatar-template";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import dNumber from "discourse/ui-kit/helpers/d-number";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:rail-contributors", {
  description: "All-time best contributors from gamification leaderboard",
  args: {
    leaderboardId: { type: "number", integer: true, default: 1 },
  },
})
export default class BlockRailContributors extends Component {
  get leaderboardId() {
    const id = Number(this.args.leaderboardId);
    return Number.isFinite(id) && id > 0 ? id : 1;
  }

  get leaderboardHref() {
    return `/leaderboard/${this.leaderboardId}?period=all_time`;
  }

  @bind
  async fetchContributors() {
    const endpoint = `/leaderboard/${this.leaderboardId}`;
    let data;

    try {
      data = await ajax(endpoint, {
        data: { user_limit: 5, period: "all_time" },
      });
    } catch {
      try {
        data = await ajax(endpoint, { data: { user_limit: 5 } });
      } catch {
        return { users: [], personal: null };
      }
    }

    const users = (data?.users || []).slice(0, 5);
    const personal = data?.personal;

    return {
      users,
      personal:
        personal?.user && personal?.position > users.length
          ? {
              username: personal.user.username,
              avatar_template: personal.user.avatar_template,
              total_score: personal.user.total_score,
              position: personal.position,
            }
          : null,
    };
  }

  <template>
    <DAsyncContent @asyncData={{this.fetchContributors}}>
      <:content as |model|>
        {{#if model.users.length}}
          <section class="block-rail-panel block-rail-contributors">
            <h4 class="block-rail-panel__title">
              {{dIcon "award"}}
              <span>{{i18n (themePrefix "rail.contributors_title")}}</span>
            </h4>
            <ul class="block-rail-contributors__list">
              {{#each model.users as |user|}}
                <li>
                  <a
                    class="block-rail-contributors__item"
                    href={{concat "/u/" user.username}}
                    data-user-card={{user.username}}
                  >
                    {{dBoundAvatarTemplate user.avatar_template "small"}}
                    <span
                      class="block-rail-contributors__name"
                    >{{user.username}}</span>
                    <span class="block-rail-contributors__score">
                      {{dNumber user.total_score}}
                      {{dIcon "award"}}
                    </span>
                  </a>
                </li>
              {{/each}}
              {{#if model.personal}}
                <li>
                  <a
                    class="block-rail-contributors__item is-self"
                    href={{concat "/u/" model.personal.username}}
                    data-user-card={{model.personal.username}}
                  >
                    {{dBoundAvatarTemplate
                      model.personal.avatar_template
                      "small"
                    }}
                    <span class="block-rail-contributors__name">
                      {{i18n
                        (themePrefix "rail.contributors_you")
                        position=model.personal.position
                      }}
                    </span>
                    <span class="block-rail-contributors__score">
                      {{dNumber model.personal.total_score}}
                      {{dIcon "award"}}
                    </span>
                  </a>
                </li>
              {{/if}}
            </ul>
            <a class="block-rail-panel__more" href={{this.leaderboardHref}}>
              <span>{{i18n (themePrefix "rail.show_all")}}</span>
              {{dIcon "arrow-right"}}
            </a>
          </section>
        {{/if}}
      </:content>
    </DAsyncContent>
  </template>
}

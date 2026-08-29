import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import UserBadge from "discourse/components/user-badge";
import { bind } from "discourse/lib/decorators";
import User from "discourse/models/user";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import dBoundAvatarTemplate from "discourse/ui-kit/helpers/d-bound-avatar-template";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:rail-profile", {
  description: "Current user summary: avatar, trust level and featured badges",
  args: {
    maxBadges: { type: "number", integer: true, default: 4 },
  },
})
export default class BlockRailProfile extends Component {
  @service currentUser;

  get maxBadges() {
    const max = Number(this.args.maxBadges);
    return Number.isFinite(max) && max > 0 ? max : 4;
  }

  // `card.json` carries trust level, badge count and featured badges in a
  // single request, unlike the current user payload which has none of them.
  @bind
  async fetchProfile() {
    const username = this.currentUser?.username;

    if (!username) {
      return null;
    }

    let user;

    try {
      user = await User.findByUsername(username, { forCard: true });
    } catch {
      return null;
    }

    return {
      user,
      displayName: user.name || user.username,
      trustLevelName: user.trustLevel?.name,
      badgeCount: user.badge_count ?? 0,
      badges: (user.featured_user_badges || [])
        .filter(Boolean)
        .slice(0, this.maxBadges),
    };
  }

  <template>
    {{#if this.currentUser}}
      <DAsyncContent @asyncData={{this.fetchProfile}}>
        <:content as |model|>
          {{#if model}}
            <section class="block-rail-panel block-rail-profile">
              <a
                class="block-rail-profile__identity"
                href={{concat "/u/" model.user.username "/summary"}}
              >
                <span class="block-rail-profile__avatar">
                  {{dBoundAvatarTemplate model.user.avatar_template "large"}}
                </span>
                <span class="block-rail-profile__names">
                  <span
                    class="block-rail-profile__name"
                  >{{model.displayName}}</span>
                  <span
                    class="block-rail-profile__username"
                  >{{model.user.username}}</span>
                </span>
              </a>

              <div class="block-rail-profile__meta">
                {{#if model.trustLevelName}}
                  <span class="block-rail-profile__level">
                    {{dIcon "award"}}
                    <span>{{model.trustLevelName}}</span>
                  </span>
                {{/if}}
                {{#if model.user.title}}
                  <span
                    class="block-rail-profile__title"
                  >{{model.user.title}}</span>
                {{/if}}
              </div>

              {{#if model.badges.length}}
                <div class="block-rail-profile__badges">
                  {{#each model.badges as |userBadge|}}
                    <UserBadge
                      @badge={{userBadge.badge}}
                      @count={{userBadge.count}}
                      @user={{model.user}}
                      @showName={{true}}
                    />
                  {{/each}}
                </div>
              {{/if}}

              <a
                class="block-rail-panel__more"
                href={{concat "/u/" model.user.username "/badges"}}
              >
                <span>{{i18n
                    (themePrefix "rail.profile_badges")
                    total=model.badgeCount
                  }}</span>
                {{dIcon "arrow-right"}}
              </a>
            </section>
          {{/if}}
        </:content>
      </DAsyncContent>
    {{/if}}
  </template>
}

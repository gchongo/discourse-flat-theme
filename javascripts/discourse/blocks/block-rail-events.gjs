import Component from "@glimmer/component";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:rail-events", {
  description: "Upcoming events from discourse-post-event",
})
export default class BlockRailEvents extends Component {
  @bind
  async fetchEvents() {
    try {
      const after = new Date().toISOString();
      const before = new Date(
        Date.now() + 180 * 24 * 60 * 60 * 1000
      ).toISOString();
      const { events } = await ajax("/discourse-post-event/events", {
        data: {
          limit: 3,
          after,
          before,
          include_ongoing: true,
        },
      });

      return (events || []).slice(0, 3).map((event) => {
        const startsAt = new Date(event.starts_at);
        return {
          href: event.post?.url || "/upcoming-events",
          title: event.name || event.post?.topic?.title || "",
          month: `${startsAt.getMonth() + 1}${i18n(themePrefix("rail.month_suffix"))}`,
          day: String(startsAt.getDate()),
        };
      });
    } catch {
      return [];
    }
  }

  <template>
    <DAsyncContent @asyncData={{this.fetchEvents}}>
      <:content as |events|>
        {{#if events.length}}
          <section class="block-rail-panel block-rail-events">
            <h4 class="block-rail-panel__title">
              {{dIcon "calendar"}}
              <span>{{i18n (themePrefix "rail.events_title")}}</span>
            </h4>
            <ul class="block-rail-events__list">
              {{#each events as |event|}}
                <li>
                  <a class="block-rail-events__item" href={{event.href}}>
                    <span class="block-rail-events__date">
                      <span class="block-rail-events__month">{{event.month}}</span>
                      <span class="block-rail-events__day">{{event.day}}</span>
                    </span>
                    <span class="block-rail-events__name">{{event.title}}</span>
                  </a>
                </li>
              {{/each}}
            </ul>
            <a class="block-rail-panel__more" href="/upcoming-events">
              <span>{{i18n (themePrefix "rail.show_all")}}</span>
              {{dIcon "arrow-right"}}
            </a>
          </section>
        {{/if}}
      </:content>
    </DAsyncContent>
  </template>
}

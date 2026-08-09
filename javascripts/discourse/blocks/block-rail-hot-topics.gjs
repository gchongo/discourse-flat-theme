import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import { relativeAge } from "discourse/lib/formatter";
import getURL from "discourse/lib/get-url";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import dCategoryBadge from "discourse/ui-kit/helpers/d-category-badge";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:rail-hot-topics", {
  description: "Hot topics list for the discovery rail",
})
export default class BlockRailHotTopics extends Component {
  @service site;

  @bind
  async fetchTopics() {
    let payload;
    try {
      payload = await ajax("/hot.json");
    } catch {
      try {
        payload = await ajax("/top.json", { data: { period: "weekly" } });
      } catch {
        return [];
      }
    }

    const topics = payload?.topic_list?.topics || [];
    return topics.slice(0, 5).map((topic) => {
      const category = this.site.categories?.find(
        (c) => c.id === topic.category_id
      );
      const tag = topic.tags?.[0];
      const tagName =
        typeof tag === "string"
          ? tag
          : tag?.name || tag?.id || tag?.text || null;

      return {
        href: getURL(`/t/${topic.slug}/${topic.id}`),
        title: htmlSafe(topic.fancy_title || topic.title),
        category,
        tag: tagName,
        age: relativeAge(new Date(topic.bumped_at || topic.created_at), {
          format: "tiny",
        }),
      };
    });
  }

  <template>
    <DAsyncContent @asyncData={{this.fetchTopics}}>
      <:content as |topics|>
        {{#if topics.length}}
          <section class="block-rail-panel block-rail-hot-topics">
            <h4 class="block-rail-panel__title">
              {{dIcon "fire"}}
              <span>{{i18n (themePrefix "rail.hot_topics_title")}}</span>
            </h4>
            <ul class="block-rail-hot-topics__list">
              {{#each topics as |topic|}}
                <li>
                  <a class="block-rail-hot-topics__item" href={{topic.href}}>
                    <span
                      class="block-rail-hot-topics__name"
                    >{{topic.title}}</span>
                    <span class="block-rail-hot-topics__meta">
                      <span class="block-rail-hot-topics__badges">
                        {{#if topic.category}}
                          {{dCategoryBadge topic.category}}
                        {{/if}}
                        {{#if topic.tag}}
                          <span
                            class="block-rail-hot-topics__tag"
                          >{{topic.tag}}</span>
                        {{/if}}
                      </span>
                      <span
                        class="block-rail-hot-topics__age"
                      >{{topic.age}}</span>
                    </span>
                  </a>
                </li>
              {{/each}}
            </ul>
            <a class="block-rail-panel__more" href="/hot">
              <span>{{i18n (themePrefix "rail.show_all")}}</span>
              {{dIcon "arrow-right"}}
            </a>
          </section>
        {{/if}}
      </:content>
    </DAsyncContent>
  </template>
}

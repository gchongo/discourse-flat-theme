import Component from "@glimmer/component";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:hero", {
  description: "Discovery hero with title and search",
  args: {
    subtitle: { type: "string" },
  },
})
export default class BlockHero extends Component {
  @service site;
  @service siteSettings;

  get title() {
    return this.siteSettings.title || this.site.title || "Community";
  }

  get description() {
    return this.args.subtitle || i18n(themePrefix("hero.default_subtitle"));
  }

  <template>
    <section class="block-hero">
      <div class="block-hero__inner">
        <div class="block-hero__copy">
          <span class="block-hero__eyebrow">{{i18n
              (themePrefix "hero.eyebrow")
            }}</span>
          <h1 class="block-hero__title">{{this.title}}</h1>
          <p class="block-hero__subtitle">{{this.description}}</p>
        </div>

        <div class="block-hero__discovery">
          <form
            class="block-hero__search"
            action="/search"
            method="get"
            role="search"
          >
            {{dIcon "magnifying-glass"}}
            <input
              type="search"
              name="q"
              placeholder={{i18n (themePrefix "hero.search_placeholder")}}
              aria-label={{i18n (themePrefix "hero.search_label")}}
              autocomplete="off"
            />
            <button type="submit" class="btn btn-primary">{{i18n
                (themePrefix "hero.search_action")
              }}</button>
          </form>
        </div>
      </div>
    </section>
  </template>
}

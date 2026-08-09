import Component from "@glimmer/component";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:hero", {
  description: "Centered discovery hero with greeting and search",
})
export default class BlockHero extends Component {
  @service currentUser;

  get greetingName() {
    if (this.currentUser) {
      return this.currentUser.name || this.currentUser.username;
    }
    return i18n(themePrefix("hero.brand_name"));
  }

  get greeting() {
    if (this.currentUser) {
      return i18n(themePrefix("hero.welcome_back"), {
        name: this.greetingName,
      });
    }
    return i18n(themePrefix("hero.welcome"), { name: this.greetingName });
  }

  <template>
    <section class="block-hero">
      <div class="block-hero__inner">
        <h1 class="block-hero__title">{{this.greeting}}</h1>

        <form
          class="block-hero__search"
          action="/search"
          method="get"
          role="search"
        >
          <span class="block-hero__search-icon" aria-hidden="true">
            {{dIcon "magnifying-glass"}}
          </span>
          <input
            type="search"
            name="q"
            placeholder={{i18n (themePrefix "hero.search_placeholder")}}
            aria-label={{i18n (themePrefix "hero.search_label")}}
            autocomplete="off"
          />
          <a
            class="block-hero__search-advanced"
            href="/search"
            title={{i18n (themePrefix "hero.advanced_search")}}
            aria-label={{i18n (themePrefix "hero.advanced_search")}}
          >
            {{dIcon "sliders"}}
          </a>
        </form>
      </div>
    </section>
  </template>
}

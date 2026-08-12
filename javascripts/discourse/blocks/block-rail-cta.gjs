import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import DButton from "discourse/ui-kit/d-button";
import { i18n } from "discourse-i18n";

@block("theme:flat-theme:rail-cta", {
  description: "Create-topic call to action card",
})
export default class BlockRailCta extends Component {
  @service composer;
  @service currentUser;
  @service router;

  get canCreateTopic() {
    return !!this.currentUser?.can_create_topic;
  }

  @action
  createTopic() {
    const route = this.router.currentRoute;
    const category = route?.attributes?.category;
    const tag = route?.attributes?.tag;

    this.composer.openNewTopic({
      category,
      tags: tag?.name,
    });
  }

  <template>
    {{#if this.canCreateTopic}}
      <div class="block-rail-cta">
        <h4 class="block-rail-cta__title">{{i18n
            (themePrefix "rail.ask_title")
          }}</h4>
        <p class="block-rail-cta__body">{{i18n
            (themePrefix "rail.ask_body")
          }}</p>
        <DButton
          @action={{this.createTopic}}
          @icon="plus"
          @translatedLabel={{i18n (themePrefix "rail.create_topic")}}
          class="btn-primary block-rail-cta__button"
        />
      </div>
    {{/if}}
  </template>
}

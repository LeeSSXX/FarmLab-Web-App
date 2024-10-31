import { Collapse } from "@blueprintjs/core";
import React from "react";
import { useNavigate } from "react-router-dom";
import { toggleHotkeyHelpOverlay } from "../hotkeys";
import { t } from "../i18next_wrapper";
import { FilePath, Icon, Path } from "../internal_urls";
import { store } from "../redux/store";
import { isMobile } from "../screen_size";

interface Page {
  title: string;
  icon?: Icon;
  fa_icon?: string;
  iconPath?: string;
  onClick?(): void;
}

type Pages = Record<string, Page>;

const PAGES = (): Pages => ({
  help: {
    title: t("Software Documentation"),
    icon: Icon.documentation,
  },
  developer: {
    title: t("Developer Documentation"),
    icon: Icon.developer,
  },
  genesis: {
    title: t("Genesis Documentation"),
    iconPath: FilePath.image("favicon", "png"),
  },
  express: {
    title: t("Express Documentation"),
    iconPath: FilePath.image("favicon", "png"),
  },
  business: {
    title: t("Business Documentation"),
    icon: Icon.shop,
  },
  education: {
    title: t("Education Documentation"),
    fa_icon: "fa-graduation-cap",
  },
  tours: {
    title: t("Take a Tour"),
    fa_icon: "fa-share",
  },
  support: {
    title: t("Get Help"),
    icon: Icon.support,
  },
});

const maybeAddHotkeysMenuItem = (): [string, Page][] =>
  !isMobile()
    ? [["hotkeys", {
      title: t("Hotkeys"),
      fa_icon: "fa-keyboard-o",
      onClick: toggleHotkeyHelpOverlay(store.dispatch),
    }]]
    : [];

export const HelpHeader = () => {
  const [isOpen, setOpen] = React.useState(false);
  const click = () => setOpen(!isOpen);
  const currentSlug = Path.getSlug(Path.designer());
  const currentPage = PAGES()[currentSlug] || PAGES().help;
  return <div className={"help-panel-header"} onClick={click}>
    {PageLink([currentSlug, currentPage])}
    <i className={`fa fa-chevron-${isOpen ? "up" : "down"}`} />
    {isOpen &&
      <Collapse isOpen={isOpen}>
        {Object.entries(PAGES())
          .filter(([slug, _page]) => slug != currentSlug)
          .concat(maybeAddHotkeysMenuItem())
          .map(PageLink)}
      </Collapse>}
  </div>;
};

const PageLink = ([slug, page]: [string, Page]) => {
  const iconSrc = page.icon ? FilePath.icon(page.icon) : page.iconPath;
  const navigate = useNavigate();
  return <a key={slug}
    title={page.title}
    onClick={() => page.onClick ? page.onClick() : navigate(Path.designer(slug))}>
    {page.fa_icon
      ? <i className={`fa ${page.fa_icon}`} />
      : <img width={25} height={25} src={iconSrc} />}
    {page.title}
  </a>;
};

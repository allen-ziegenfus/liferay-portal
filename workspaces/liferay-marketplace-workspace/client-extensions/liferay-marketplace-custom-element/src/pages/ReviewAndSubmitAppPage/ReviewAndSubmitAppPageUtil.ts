export type File = {
  image: string;
  fileName: string;
  fileDescription: string;
};

export type CardInfo = {
  icon: string;
  title: string;
  link: string;
};

export type CardTag = {
  icon: string;
  title: string;
  tags: string[];
};

export type ReviewAndSubmitAppPageUtilProps = {
  cardInfos?: CardInfo[];
  cardTags?: CardTag[];
  description?: string;
  icon?: string;
  fileName?: string;
  files?: File[];
  section: string;
  tags?: string[];
  title?: string;
  version?: string;
};

import brightnessEmptyIcon from "../../assets/icons/brightness-empty.svg";
import documentationIcon from "../../assets/icons/documentation-icon.svg";
import phoneIcon from "../../assets/icons/phone-icon.svg";
import identifiersIcon from "../../assets/icons/identifiers-icon.svg";
import browsingHistoryIcon from "../../assets/icons/browsing-history-icon.svg";
import financialIcon from "../../assets/icons/financial-icon.svg";
import contactIcon from "../../assets/icons/person-fill.svg";
import guideIcon from "../../assets/icons/guide-icon.svg";
import userDataIcon from "../../assets/icons/user-data-icon.svg";
import globeIcon from "../../assets/icons/globe-icon.svg";
import diagnosticsIcon from "../../assets/icons/diagnostics-icon.svg";
import usageTermsIcon from "../../assets/icons/usage-terms-icon.svg";
import scheduleIcon from "../../assets/icons/schedule-icon.svg";
import file1 from "../../assets/images/file1.svg";
import file2 from "../../assets/images/file2.svg";


export const initialReviewAndSubmitAppPageItems: ReviewAndSubmitAppPageUtilProps[] =
  [
    {
      section: "Categories",
      tags: ["Experience Management", "Collaboration and Knowledge Sharing"],
    },
    {
      section: "Tags",
      tags: [
        "CRM",
        "Employee Experience",
        "Employee Portal",
        "Knowledge Management",
      ],
    },
    {
      section: "Build",
      fileName: "a-co-libraries-01.lpkg",
    },
    {
      description: "The app is offered in the Marketplace with no charge.",
      icon: brightnessEmptyIcon,
      section: "Pricing",
      title: "Free",
    },
    {
      description: "License never expires.",
      icon: scheduleIcon,
      section: "Licensing",
      title: "Perpetual License",
    },
    {
      section: "Storefront",
      files: [
        {
          fileDescription:
            "Morbi leo risus, porta ac consectetur ac, vestibulum at eros.",
          fileName: "file-name",
          image: file1,
        },
        {
          fileDescription:
            "Morbi leo risus, porta ac consectetur ac, vestibulum at eros.",
          fileName: "Image 2",
          image: file2,
        },
      ],
    },
    {
      description:
        "Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec sed odio dui. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Cras mattison purus sit amet fermentum.",
      section: "Version",
      title: "Release Notes",
      version: "0.0.1",
    },
    {
      cardInfos: [
        {
          icon: phoneIcon,
          title: "Support URL",
          link: "acme.co/support",
        },
        {
          icon: globeIcon,
          title: "Publisher website URL",
          link: "acme.co",
        },
        {
          icon: usageTermsIcon,
          title: "App usage terms (EULA) URL",
          link: "acme.co/eula",
        },
        {
          icon: documentationIcon,
          title: "App documentation URL",
          link: "acme.co/docs",
        },
        {
          icon: guideIcon,
          title: "App installation guide URL",
          link: "acme.co/apps/data-viz",
        },
      ],
      section: "Support & Help",
    },
  ];

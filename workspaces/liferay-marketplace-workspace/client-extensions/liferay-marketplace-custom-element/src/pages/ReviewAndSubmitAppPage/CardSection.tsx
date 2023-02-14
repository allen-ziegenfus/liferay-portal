import { CardView } from "../../components/Card/CardView";
import { CardLink } from "../../components/Card/CardLink";
import { CardTags } from "../../components/Card/CardTags";

import { Tag } from "../../components/Tag/Tag";
import {RequiredMask} from "../../components/FieldBase";

import ClayButton from "@clayui/button";
import { Tooltip } from "../../components/Tooltip/Tooltip";
import arrowDown from "../../assets/icons/arrow-down.svg";

import documentIcon from "../../assets/icons/document-icon.svg";
import folderIcon from "../../assets/icons/folder-fill.svg";

import {File} from "./ReviewAndSubmitAppPageUtil";

import './CardSection.scss';



interface CardSectionProps {
    build?: boolean;
    cardInfo?: { title: string; link: string; icon: string }[];
    cardTitle?: string;
    enableEdit?: boolean;
    files?: File[];
    cardDescription?: string;
    paragraph?: string;
    description?: string;
    title?: string;
    icon?: string;
    cardView?: boolean;
    cardLink?: boolean;
    cardTags?: { icon: string; title: string; tags: string[] }[];
    required?: boolean;
    sectionName?: string;
    storefront?: boolean;
    tags?: string[];
    version?: string;
    localized?: boolean;
  }
  
export function CardSection({
    build,
    cardInfo,
    cardTitle,
    cardDescription,
    enableEdit = true,
    files,
    paragraph,
    description,
    title,
    icon,
    cardView,
    cardLink,
    cardTags,
    required,
    sectionName,
    storefront,
    tags,
    version,
    localized,
  }: CardSectionProps) {
    return (
      <div className="card-section-body-section">
        <div className="card-section-body-section-header">
          <span className="card-section-body-section-header-title">
            {sectionName}
            {required && <RequiredMask />}
          </span>
  
          <div className="card-section-body-section-header-actions">
            {localized && (
                <div className="field-base-localized-field">

                <ClayButton displayType={null}>
                    {"English (US)"}
                    <img className="arrow-down-icon" src={arrowDown} />
                </ClayButton>
    
                <>
                    &nbsp;
                    <Tooltip tooltip={"choose a language"} />
                </>
                </div>    
            )}


            {enableEdit && (
                <ClayButton className="edit-button" displayType={null}>
                {"Edit"}
                </ClayButton>
            )}
          </div>
        </div>
  
        {tags && (
          <div className="card-section-body-section-tags">
            {tags.map((tag) => {
              return <Tag label={tag}></Tag>;
            })}
          </div>
        )}
  
        {paragraph && (
          <p className="card-section-body-section-paragraph">
            {paragraph}
          </p>
        )}
  
        {build && (
          <div className="card-section-body-section-file">
            <div className="card-section-body-section-file-container">
              <img
                className="card-section-body-section-file-container-icon"
                src={folderIcon}
                alt="Folder Icon"
              />
            </div>
            <img
              className="card-section-body-section-file-icon"
              src={documentIcon}
              alt="Document Icon"
            />
            <span className="card-section-body-section-file-name">
              {title}
            </span>
          </div>
        )}
  
        {cardView && (
          <CardView
            icon={icon}
            title={cardTitle as string}
            description={cardDescription as string}
          />
        )}
  
        {storefront && (
          <div>
            {files?.map(({ fileDescription, fileName, image }) => {
              return (
                <div className="card-section-body-section-files">
                  <div className="card-section-body-section-files-container">
                    <img src={image} alt={fileName} />
                  </div>
                  <div className="card-section-body-section-files-data">
                    <img
                      className="card-section-body-section-files-data-icon"
                      src={documentIcon}
                      alt={fileName}
                    />
                    <span className="card-section-body-section-files-data-name">
                      {fileName}
                    </span>
                    <span className="card-section-body-section-files-data-description">
                      {fileDescription}
                    </span>
                  </div>
                </div>
              );
            })}
            <div className="card-section-body-section-files-info">
                        {"Important: Images will be displayed following the numerical order above"}
                      </div>
          </div>
        )}
  
        {version && (
          <div className="card-section-body-section-version">
            <div className="card-section-body-section-version-container">
              <div className="card-section-body-section-version-container-icon">
                {version}
              </div>
            </div>
            <div className="card-section-body-section-version-data">
              <span className="card-section-body-section-version-data-name">
                {title}
              </span>
              <span className="card-section-body-section-version-data-description">
                {description}
              </span>
            </div>
          </div>
        )}
  
        {cardLink &&
          cardInfo?.map(({ icon, link, title }) => {
            return (
              <CardLink
                icon={icon}
                title={title as string}
                description={link as string}
              />
            );
          })}
  
        {cardTags &&
          cardTags?.map(({ icon, tags, title }) => {
            return <CardTags icon={icon} title={title as string} tags={tags} />;
          })}
      </div>
    );
  }
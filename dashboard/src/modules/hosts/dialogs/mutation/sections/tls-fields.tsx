import { AllowInsecureField, AlpnField } from "../fields";
import { SettingSection } from "@freeway/modules/hosts/components";
import { useTranslation } from "react-i18next";
import { FC } from "react";
import { ClearableTextField } from "@freeway/common/components";

export const TlsFields: FC = () => {
    const { t } = useTranslation();
    return (
        <SettingSection
            value="tls-settings"
            triggerText={t("page.hosts.tls-config")}
        >
            <ClearableTextField name="sni" label={t("sni")} />
            <AlpnField />
            <AllowInsecureField />
        </SettingSection>
    );
};

import { type FC } from "react";
import { BooleanPill } from "@freeway/common/components";
import { useTranslation } from "react-i18next";
import { UserProp } from "@freeway/modules/users";

export const UserEnabledPill: FC<UserProp> = ({ user }) => {
    const { t } = useTranslation();
    return (
        <BooleanPill
            active={user.enabled}
            activeLabel={t('enabled')}
            inactiveLabel={t('disabled')}
        />
    )
}

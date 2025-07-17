import { BadgeVariantKeys } from "@freeway/common/components";
import { LucideIcon } from "lucide-react";

export interface StatusType {
    label: string;
    icon: LucideIcon | null;
    variant?: BadgeVariantKeys | undefined
}

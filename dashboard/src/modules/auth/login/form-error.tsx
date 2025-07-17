import { Alert, AlertDescription, AlertTitle } from "@freeway/common/components"
import { cn } from "@freeway/common/utils";

interface FormErrorProps {
    className: string;
    title: string;
    desc: string;
}

export const FormError = ({ className, title, desc }: FormErrorProps) => {
    return (
        <Alert variant='destructive' className={cn(className, "p-3 bg-destructive-accent")}>
            <AlertTitle className="font-semibold font-header">{title}</AlertTitle>
            <AlertDescription>{desc}</AlertDescription>
        </Alert>
    )
}

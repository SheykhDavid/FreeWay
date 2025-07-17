
import { FC } from "react";
import { DoubleEntityTable } from "@freeway/libs/entity-table";
import { columns } from "./columns";
import { fetchServiceUsers, type ServiceType } from "@freeway/modules/services";

interface ServicesUsersTableProps {
    service: ServiceType
}

export const ServicesUsersTable: FC<ServicesUsersTableProps> = ({ service }) => {

    return (
        <DoubleEntityTable
            columns={columns}
            entityId={service.id}
            fetchEntity={fetchServiceUsers}
            primaryFilter="username"
            entityKey='services'
        />
    )
}

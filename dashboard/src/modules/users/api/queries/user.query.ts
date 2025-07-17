import { queryOptions, useQuery } from "@tanstack/react-query";
import { fetch } from "@freeway/common/utils";
import type { UserType } from "@freeway/modules/users";

export async function fetchUser({
    queryKey,
}: { queryKey: [string, string] }): Promise<UserType> {
    return fetch(`/users/${queryKey[1]}`);
}

export const UserQueryFetchKey = "users";

export const userQueryOptions = ({ username }: { username: string }) => {
    return queryOptions({
        queryKey: [UserQueryFetchKey, username],
        queryFn: fetchUser,
    });
};

export const useUserQuery = ({ username }: { username: string }) => {
    return useQuery(userQueryOptions({ username }));
};

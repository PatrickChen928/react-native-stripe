create table "public"."Post" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "creator" uuid,
    "caption" text,
    "tags" character varying[],
    "imageUrl" character varying,
    "imageId" character varying,
    "location" text,
    "likes" uuid[]
);


alter table "public"."Post" enable row level security;

create table "public"."Save" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "user" uuid,
    "post" uuid
);


alter table "public"."Save" enable row level security;

create table "public"."User" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "username" character varying,
    "email" character varying,
    "bio" text,
    "imageUrl" character varying,
    "imageId" character varying
);


alter table "public"."User" enable row level security;

create table "public"."customers" (
    "id" uuid not null,
    "stripe_customer_id" text
);


alter table "public"."customers" enable row level security;

CREATE UNIQUE INDEX "Post_pkey" ON public."Post" USING btree (id);

CREATE UNIQUE INDEX "Save_pkey" ON public."Save" USING btree (id);

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);

CREATE UNIQUE INDEX "User_pkey" ON public."User" USING btree (id);

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);

CREATE UNIQUE INDEX customers_pkey ON public.customers USING btree (id);

alter table "public"."Post" add constraint "Post_pkey" PRIMARY KEY using index "Post_pkey";

alter table "public"."Save" add constraint "Save_pkey" PRIMARY KEY using index "Save_pkey";

alter table "public"."User" add constraint "User_pkey" PRIMARY KEY using index "User_pkey";

alter table "public"."customers" add constraint "customers_pkey" PRIMARY KEY using index "customers_pkey";

alter table "public"."Post" add constraint "public_Post_creator_fkey" FOREIGN KEY (creator) REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Post" validate constraint "public_Post_creator_fkey";

alter table "public"."Save" add constraint "public_Save_post_fkey" FOREIGN KEY (post) REFERENCES "Post"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Save" validate constraint "public_Save_post_fkey";

alter table "public"."Save" add constraint "public_Save_user_fkey" FOREIGN KEY ("user") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Save" validate constraint "public_Save_user_fkey";

alter table "public"."User" add constraint "User_email_key" UNIQUE using index "User_email_key";

alter table "public"."User" add constraint "User_username_key" UNIQUE using index "User_username_key";

alter table "public"."customers" add constraint "customers_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) not valid;

alter table "public"."customers" validate constraint "customers_id_fkey";

grant delete on table "public"."Post" to "anon";

grant insert on table "public"."Post" to "anon";

grant references on table "public"."Post" to "anon";

grant select on table "public"."Post" to "anon";

grant trigger on table "public"."Post" to "anon";

grant truncate on table "public"."Post" to "anon";

grant update on table "public"."Post" to "anon";

grant delete on table "public"."Post" to "authenticated";

grant insert on table "public"."Post" to "authenticated";

grant references on table "public"."Post" to "authenticated";

grant select on table "public"."Post" to "authenticated";

grant trigger on table "public"."Post" to "authenticated";

grant truncate on table "public"."Post" to "authenticated";

grant update on table "public"."Post" to "authenticated";

grant delete on table "public"."Post" to "service_role";

grant insert on table "public"."Post" to "service_role";

grant references on table "public"."Post" to "service_role";

grant select on table "public"."Post" to "service_role";

grant trigger on table "public"."Post" to "service_role";

grant truncate on table "public"."Post" to "service_role";

grant update on table "public"."Post" to "service_role";

grant delete on table "public"."Save" to "anon";

grant insert on table "public"."Save" to "anon";

grant references on table "public"."Save" to "anon";

grant select on table "public"."Save" to "anon";

grant trigger on table "public"."Save" to "anon";

grant truncate on table "public"."Save" to "anon";

grant update on table "public"."Save" to "anon";

grant delete on table "public"."Save" to "authenticated";

grant insert on table "public"."Save" to "authenticated";

grant references on table "public"."Save" to "authenticated";

grant select on table "public"."Save" to "authenticated";

grant trigger on table "public"."Save" to "authenticated";

grant truncate on table "public"."Save" to "authenticated";

grant update on table "public"."Save" to "authenticated";

grant delete on table "public"."Save" to "service_role";

grant insert on table "public"."Save" to "service_role";

grant references on table "public"."Save" to "service_role";

grant select on table "public"."Save" to "service_role";

grant trigger on table "public"."Save" to "service_role";

grant truncate on table "public"."Save" to "service_role";

grant update on table "public"."Save" to "service_role";

grant delete on table "public"."User" to "anon";

grant insert on table "public"."User" to "anon";

grant references on table "public"."User" to "anon";

grant select on table "public"."User" to "anon";

grant trigger on table "public"."User" to "anon";

grant truncate on table "public"."User" to "anon";

grant update on table "public"."User" to "anon";

grant delete on table "public"."User" to "authenticated";

grant insert on table "public"."User" to "authenticated";

grant references on table "public"."User" to "authenticated";

grant select on table "public"."User" to "authenticated";

grant trigger on table "public"."User" to "authenticated";

grant truncate on table "public"."User" to "authenticated";

grant update on table "public"."User" to "authenticated";

grant delete on table "public"."User" to "service_role";

grant insert on table "public"."User" to "service_role";

grant references on table "public"."User" to "service_role";

grant select on table "public"."User" to "service_role";

grant trigger on table "public"."User" to "service_role";

grant truncate on table "public"."User" to "service_role";

grant update on table "public"."User" to "service_role";

grant delete on table "public"."customers" to "anon";

grant insert on table "public"."customers" to "anon";

grant references on table "public"."customers" to "anon";

grant select on table "public"."customers" to "anon";

grant trigger on table "public"."customers" to "anon";

grant truncate on table "public"."customers" to "anon";

grant update on table "public"."customers" to "anon";

grant delete on table "public"."customers" to "authenticated";

grant insert on table "public"."customers" to "authenticated";

grant references on table "public"."customers" to "authenticated";

grant select on table "public"."customers" to "authenticated";

grant trigger on table "public"."customers" to "authenticated";

grant truncate on table "public"."customers" to "authenticated";

grant update on table "public"."customers" to "authenticated";

grant delete on table "public"."customers" to "service_role";

grant insert on table "public"."customers" to "service_role";

grant references on table "public"."customers" to "service_role";

grant select on table "public"."customers" to "service_role";

grant trigger on table "public"."customers" to "service_role";

grant truncate on table "public"."customers" to "service_role";

grant update on table "public"."customers" to "service_role";

create policy "Enable read access for all users"
on "public"."Post"
as permissive
for all
to public
using (true);


create policy "Enable read access for all users"
on "public"."Save"
as permissive
for all
to public
using (true);


create policy "Enable read access for all users"
on "public"."User"
as permissive
for all
to public
using (true);


create policy "Can read own data"
on "public"."customers"
as permissive
for select
to public
using ((auth.uid() = id));


create policy "Enable read access for all users"
on "public"."customers"
as permissive
for all
to public
using (true);




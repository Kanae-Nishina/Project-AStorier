"use client";

import { Delete2API, GetFromAPI, Put2API, useRouter } from "@/lib";
import { userState } from "@/recoilState";
import { RouterPath } from "@/settings";
import { IEditIllustData, IPublicState } from "@/types";
import * as Mantine from "@mantine/core";
import { Dropzone, IMAGE_MIME_TYPE } from "@mantine/dropzone";
import { useForm } from "@mantine/form";
import { useMediaQuery } from "@mantine/hooks";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { useRecoilValue, useSetRecoilState } from "recoil";
import { FaImage } from "rocketicons/fa";
import useSWR, { mutate } from "swr";
import { XShare } from "@/components/features/illusts";

const fetcher = (url: string) => GetFromAPI(url).then((res) => res.data);

const fetcherTags = (url: string) => GetFromAPI(url).then((res) => res.data);

const fetcherSynalios = (url: string) =>
  GetFromAPI(url).then((res) => res.data);

const fetcherGameSystems = (url: string) =>
  GetFromAPI(url).then((res) => res.data);

export default function IllustEditPage({
  params,
}: {
  params: { uuid: string };
}) {
  const { uuid } = params;
  const { data, error } = useSWR(`/posts/${uuid}/edit`, fetcher);
  const illustData = data
    ? ({
        title: data.title,
        caption: data.caption,
        publish_state: data.publish_state,
        image: data.data,
        tags: data.tags,
        synalio: data.synalio,
        game_system: data.game_systems,
      } as IEditIllustData)
    : ({} as IEditIllustData);
  const { data: Tags, error: errorTags } = useSWR("/tags", fetcherTags);
  const { data: Synalios, error: errorSynalios } = useSWR(
    "/synalios",
    fetcherSynalios
  );
  const { data: GameSystems, error: errorGameSystems } = useSWR(
    "/game_systems",
    fetcherGameSystems
  );
  const [postIllust, setPostIllust] = useState<string[]>([]);
  const theme = Mantine.useMantineTheme();
  const mobile = useMediaQuery(`(max-width: ${theme.breakpoints.sm})`);
  const [openModal, setOpenModal] = useState<boolean>(false);
  const [tags, setTags] = useState<string[]>([]);
  const router = useRouter();
  const user = useRecoilValue(userState);
  const t_PostIllustEdit = useTranslations("PostIllustEdit");
  const t_PostGeneral = useTranslations("PostGeneral");
  const t_General = useTranslations("General");
  const t_EditGeneral = useTranslations("EditGeneral");
  const [isDelete, setIsDelete] = useState<boolean>(false);
  const [isDeleteConfirmation, setIsDeleteConfirmation] =
    useState<boolean>(false);
  const [deleteConfirmationError, setDeleteConfirmationError] =
    useState<string>("");
  const [errorMessage, setErrorMessage] = useState<string>("");
  const TITLE_MAX_LENGTH = 20;
  const CAPTION_MAX_LENGTH = 10000;
  const MEGA_BITE = 1024 ** 2;
  const MAX_SIZE = 10 * MEGA_BITE;

  const form = useForm({
    initialValues: {
      postIllust: illustData?.image || [],
      title: illustData?.title || "",
      caption: illustData?.caption || "",
      publishRange: illustData?.publish_state || "",
      synalioTitle: illustData?.synalio || "",
      gameSystem: illustData?.game_system || "",
      tags: illustData?.tags || [],
    },
    validate: {
      postIllust: () => {
        if (postIllust.length === 0) {
          return t_PostIllustEdit("uploadValid");
        }
      },
      title: (value) => {
        if (!value) {
          return t_PostGeneral("titleValid");
        }
      },
      publishRange: (value) => {
        if (!value) {
          return t_PostGeneral("publishValid");
        }
      },
    },
  });

  useEffect(() => {
    if (Object.keys(illustData).length === 0 || postIllust.length > 0) {
      return;
    }
    setPostIllust(illustData.image ?? []);
    setTags(illustData.tags ?? []);
    form.setValues({
      postIllust: illustData.image,
      title: illustData?.title,
      caption: illustData?.caption,
      publishRange: illustData?.publish_state,
      synalioTitle: illustData?.synalio,
      gameSystem: illustData?.game_system,
    });
  }, [illustData]);

  const getFetcherError = () => {
    return error || errorTags || errorSynalios || errorGameSystems;
  };

  const disableData = () => {
    return (
      data === undefined ||
      Tags === undefined ||
      Synalios === undefined ||
      GameSystems === undefined
    );
  };

  if (getFetcherError()) return <div>error</div>;
  if (disableData()) return <div>Now Loading</div>;

  const handleSubmit = async () => {
    const { title, caption, publishRange, synalioTitle, gameSystem } =
      form.getValues();

    const update = {
      post: {
        title,
        caption,
        tags,
        synalios: [synalioTitle],
        publish_state: publishRange,
        postable_type: "Illust",
        postable_attributes: postIllust,
        game_systems: [gameSystem],
      },
    };

    try {
      const res = await Put2API(`/posts/${uuid}`, JSON.stringify(update));
      setErrorMessage("");
      if (res.status != 200) {
        setErrorMessage(t_EditGeneral("updateError"));
        return;
      }
      mutate(`/posts/${uuid}/edit`);
      mutate(`/posts/${uuid}`);
    } catch (e) {
      setErrorMessage(t_EditGeneral("updateError"));
      return;
    } finally {
      setOpenModal(true);
    }
  };

  const handleDelete = () => {
    setOpenModal(true);
    setIsDelete(true);
  };

  const handleDeleteSubmit = async () => {
    if (!isDeleteConfirmation) {
      setDeleteConfirmationError(t_EditGeneral("checkDeleteValid"));
      return;
    }

    try {
      const res = await Delete2API(`/posts/${uuid}`);
      if (res.status != 200) {
        setErrorMessage(t_EditGeneral("deleteError"));
        return;
      }
      mutate(`/posts/${uuid}/edit`);
      mutate(`/posts/${uuid}`);
      router.push(RouterPath.users(user.uuid));
    } catch (e) {
      setErrorMessage(t_EditGeneral("deleteError"));
      return;
    } finally {
      setOpenModal(false);
    }
  };

  const handleDrop = (files: File[]) => {
    // TODO : 一枚のみ対応、後々複数枚対応する
    const reader = new FileReader();
    reader.onload = () => {
      setPostIllust([reader.result as string]);
    };
    reader.readAsDataURL(files[0]);
  };

  const handleModalClose = () => {
    setIsDelete(false);
    setIsDeleteConfirmation(false);
    setDeleteConfirmationError("");
    setOpenModal(false);
    router.back();
  };

  return (
    <>
      <article className="mt-8 mb-12">
        <Mantine.Container size={"sm"}>
          <Mantine.Box className="bg-white p-4 px-8 rounded">
            <div className="text-end">
              <Mantine.Button
                type="button"
                onClick={() => {
                  router.back();
                }}
                size="xs"
                color="transparent"
                className="text-blue-500 hover:text-blue-300 transition-all hover:bg-transparent"
              >
                {t_General("back")}
              </Mantine.Button>
            </div>
            <h1 className="text-center font-semibold my-4">
              {t_PostIllustEdit("title")}
            </h1>
            <form
              className="flex flex-col gap-5"
              onSubmit={form.onSubmit(handleSubmit)}
            >
              <section>
                {illustData?.publish_state === IPublicState.Draft ? (
                  <>
                    <label htmlFor="postIllust">
                      {t_PostIllustEdit("upload")}
                      <span className="text-red-600">*</span>
                    </label>
                    <Dropzone
                      name="postIllust"
                      onDrop={(files) => handleDrop(files)}
                      maxSize={MAX_SIZE}
                      accept={IMAGE_MIME_TYPE}
                      style={{
                        height: mobile ? "15rem" : "30rem",
                        width: "auto",
                        margin: "0 auto",
                        position: "relative",
                        cursor: "pointer",
                      }}
                      {...form.getInputProps("postIllust")}
                    >
                      <Dropzone.Idle>
                        {postIllust.length > 0 && (
                          <Mantine.Image
                            src={postIllust[0]}
                            h={mobile ? "15rem" : "30rem"}
                            w="auto"
                            m="auto"
                            fit="cover"
                            className="opacity-50"
                          />
                        )}
                        <FaImage
                          className="icon-black opacity-50 absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2"
                          style={{
                            width: "3rem",
                            height: "3rem",
                          }}
                        />
                      </Dropzone.Idle>
                    </Dropzone>
                    {form.errors.postIllust && (
                      <p className="text-sm text-red-500">
                        {form.errors.postIllust}
                      </p>
                    )}
                  </>
                ) : (
                  <>
                    {postIllust.length > 0 && (
                      <Mantine.Image
                        src={postIllust[0]}
                        h={mobile ? "15rem" : "30rem"}
                        w="auto"
                        m="auto"
                        fit="cover"
                      />
                    )}
                    <p className="text-center text-sm">
                      ※{t_PostIllustEdit("illustPostAttention")}
                    </p>
                  </>
                )}
              </section>
              <section>
                <Mantine.TextInput
                  withAsterisk
                  maxLength={TITLE_MAX_LENGTH}
                  label={t_PostGeneral("title")}
                  name="title"
                  {...form.getInputProps("title")}
                />
              </section>
              <section>
                <Mantine.Textarea
                  name="caption"
                  label={t_PostGeneral("caption")}
                  size="sm"
                  radius="xs"
                  rows={5}
                  maxLength={CAPTION_MAX_LENGTH}
                  {...form.getInputProps("caption")}
                />
              </section>
              <section>
                <Mantine.TagsInput
                  name="tags"
                  label={t_PostGeneral("tag")}
                  splitChars={[" ", "|"]}
                  data={Tags}
                  onChange={setTags}
                  value={tags}
                />
              </section>
              <section className="flex gap-5 flex-col md:flex-row md:items-center md:gap-2 w-full ">
                <div className="md:w-1/3">
                  <Mantine.Autocomplete
                    name="gameSystem"
                    label={t_PostGeneral("gameSystem")}
                    data={GameSystems}
                    {...form.getInputProps("gameSystem")}
                  />
                </div>
                <div className="md:w-2/3">
                  <Mantine.Autocomplete
                    name="synalioTitle"
                    label={t_PostGeneral("synalioTitle")}
                    data={Synalios}
                    {...form.getInputProps("synalioTitle")}
                  />
                </div>
              </section>
              <section>
                <Mantine.Radio.Group
                  name="publishRange"
                  label={t_PostGeneral("publishRange")}
                  withAsterisk
                  value={form.values.publishRange}
                  {...form.getInputProps("publishRange")}
                >
                  <Mantine.Group>
                    <Mantine.Radio
                      label={t_PostGeneral("allPublish")}
                      value={IPublicState.All}
                      style={{ cursor: "pointer" }}
                    />
                    <Mantine.Radio
                      label={t_PostGeneral("urlPublish")}
                      value={IPublicState.URL}
                      style={{ cursor: "pointer" }}
                    />
                    {/* <Mantine.Radio
                      label={t_PostGeneral("followerPublish")}
                      value={IPublicState.Follower}
                      style={{ cursor: "pointer" }}
                    /> */}
                    <Mantine.Radio
                      label={t_PostGeneral("private")}
                      value={IPublicState.Private}
                      style={{ cursor: "pointer" }}
                    />
                  </Mantine.Group>
                </Mantine.Radio.Group>
                <p className="text-sm my-4">
                  {t_PostGeneral("publishAttention")}
                </p>
              </section>
              <section className="my-8">
                <Mantine.Group className="flex justify-center items-center">
                  {illustData?.publish_state === IPublicState.Draft ? (
                    <>
                      <Mantine.Button
                        type="submit"
                        className="bg-green-300 text-black hover:bg-green-500 hover:text-black transition-all"
                      >
                        {t_PostGeneral("post")}
                      </Mantine.Button>
                      <Mantine.Button
                        type="submit"
                        onClick={() => {
                          form.setValues({ publishRange: IPublicState.Draft });
                          form.onSubmit(handleSubmit);
                        }}
                        className="bg-slate-500 hover:bg-slate-800 transition-all"
                      >
                        {t_PostGeneral("draftSave")}
                      </Mantine.Button>
                    </>
                  ) : (
                    <Mantine.Button
                      type="submit"
                      className="bg-green-300 text-black hover:bg-green-500 hover:text-black transition-all"
                    >
                      {t_EditGeneral("update")}
                    </Mantine.Button>
                  )}
                  <Mantine.Button
                    type="button"
                    onClick={handleDelete}
                    className="bg-red-500 hover:bg-red-800 transition-all"
                  >
                    {t_PostGeneral("delete")}
                  </Mantine.Button>
                </Mantine.Group>
              </section>
            </form>
          </Mantine.Box>
        </Mantine.Container>
      </article>

      <Mantine.Modal opened={openModal} onClose={handleModalClose}>
        {errorMessage === "" ? (
          isDelete ? (
            <>
              <h3 className="text-xl text-center my-4">
                {t_EditGeneral("deleteModalTItle")}
              </h3>
              <p className="text-center text-sm">
                {t_EditGeneral("deleteModalAttention")}
              </p>
              <div className="my-4 flex flex-col justify-center items-center">
                <Mantine.Checkbox
                  label={t_EditGeneral("deleteCheckLabel")}
                  size="md"
                  radius="xl"
                  color="red"
                  checked={isDeleteConfirmation}
                  onChange={(event) =>
                    setIsDeleteConfirmation(event.currentTarget.checked)
                  }
                />
                {deleteConfirmationError && (
                  <p className="text-red-400">{deleteConfirmationError}</p>
                )}
              </div>
              <div className="flex flex-col justify-center items-center gap-4 my-8">
                <Mantine.Button
                  type="button"
                  className="bg-red-400 hover:bg-red-600 transition-all text-white px-8 py-1"
                  onClick={handleDeleteSubmit}
                >
                  {t_EditGeneral("deleteButton")}
                </Mantine.Button>
                <Mantine.Button
                  type="button"
                  className="tracking-wider text-black hover:text-black hover:text-opacity-50 transition-all bg-transparent hover:bg-transparent"
                  onClick={() => {
                    setIsDelete(false);
                    setOpenModal(false);
                  }}
                >
                  {t_General("back")}
                </Mantine.Button>
              </div>
            </>
          ) : (
            <>
              <h3 className="text-xl text-center my-4">
                {form.values.publishRange === IPublicState.Draft
                  ? t_PostGeneral("draftSaved")
                  : t_PostGeneral("posted")}
              </h3>
              <Mantine.Group justify="center" gap={8}>
                {form.values.publishRange === IPublicState.Draft ? (
                  <>
                    <Mantine.Button
                      className="bg-green-300 text-black"
                      onClick={handleModalClose}
                    >
                      {t_PostGeneral("close")}
                    </Mantine.Button>
                  </>
                ) : (
                  <>
                    <Mantine.Button
                      className="bg-green-300 hover:bg-green-500 transition-all text-black"
                      onClick={() => {
                        router.push(RouterPath.illust(uuid));
                        setOpenModal(false);
                      }}
                    >
                      {t_PostGeneral("showPost")}
                    </Mantine.Button>
                    <XShare postUuid={uuid} title={form.getValues().title} />
                  </>
                )}
              </Mantine.Group>
            </>
          )
        ) : (
          <p className="text-black text-center">{errorMessage}</p>
        )}
      </Mantine.Modal>
    </>
  );
}
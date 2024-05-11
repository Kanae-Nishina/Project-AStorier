import * as Mantine from "@mantine/core";
import * as UI from "@/components/ui";
import { IndexIllustData, IUserPageEdit } from "@/types";
import { Illust } from "@/components/features/illusts";
import { useTranslations } from "next-intl";
import * as Users from "@/components/features/users";

// 仮データをハードコーディング
const illusts = Array.from({ length: 20 }).map((_, i) => ({
  id: i,
  image: "/assets/900x1600.png",
  title: `イラスト${i}`,
  user: {
    id: i,
    name: `ユーザー${i}`,
    avatar: "/assets/900x1600.png",
  },
  count: Math.floor(Math.random() * 2) + 1,
}));

export default function UserPage() {
  const imgUrl = ""; // TODO : ユーザーヘッダーのURLを取得
  const t_UserPage = useTranslations("UserPage");
  const userProfile = {
    headerImage: "",
    avatar: "",
    link: {
      twitter: "",
      pixiv: "",
      fusetter: "",
      privatter: "",
      other: "",
    },
    profile:
      "プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文プロフィール文",
  } as IUserPageEdit;

  return (
    <>
      <article className="w-full relative mb-8">
        <section className="w-full h-full relative z-0">
          {/* ヘッダー画像 */}
          <div className="absolute top-0 left-0 w-full h-[180px] md:h-[300px] -z-10">
            {imgUrl.length === 0 ? (
              <div className="w-full h-full bg-slate-400"></div>
            ) : (
              <Mantine.Image
                src={imgUrl}
                alt={t_UserPage("headerImage")}
                className="object-cover h-full w-full"
              />
            )}
          </div>

          {/* ユーザー情報 */}
          <div className="w-full pt-[140px] md:pt-[240px] px-4 m-auto md:container">
            <div className="flex flex-col justify-center items-center w-full">
              <div className="w-full relative flex md:gap-3 md:mb-8">
                <Mantine.Avatar
                  size={150}
                  alt={t_UserPage("avatar")}
                  src="https://placehold.jp/300x300.png" // TODO : ユーザーアイコンのURLを取得
                />

                <div className="w-full flex flex-col justify-start items-end md:items-start md:justify-start md:relative">
                  {/* ユーザー編集 */}
                  <Users.UserEdit userProfile={userProfile} />
                  <div className="hidden md:block md:h-1/3">
                    <h2 className="text-3xl">
                      <span className="pb-2 border-b-2 border-green-300 px-1 pr-3">
                        ユーザー名
                      </span>
                    </h2>
                  </div>
                  {userProfile.link && (
                    <ul className="flex justify-start items-center mt-auto ml-2 flex-wrap gap-2 md:h-2/3">
                      {userProfile.link.twitter && (
                        <li>
                          <a
                            href="#"
                            className="text-white bg-black hover:bg-gray-600 transition-all px-2 py-1 rounded text-sm"
                            target="_blank"
                          >
                            X
                          </a>
                        </li>
                      )}
                      {userProfile.link.pixiv && (
                        <li>
                          <a
                            href="#"
                            className="text-white bg-sky-400 transition-all hover:bg-sky-700 px-2 py-1 rounded text-sm"
                            target="_blank"
                          >
                            pixiv
                          </a>
                        </li>
                      )}
                      {userProfile.link.fusetter && (
                        <li>
                          <a
                            href="#"
                            className="text-white bg-orange-500 bg-opacity-80 hover:bg-orange-800 transition-all px-2 py-1 rounded text-sm"
                            target="_blank"
                          >
                            {t_UserPage("fusetter")}
                          </a>
                        </li>
                      )}
                      {userProfile.link.privatter && (
                        <li>
                          <a
                            href="#"
                            className="text-white bg-sky-500 transition-all hover:bg-sky-700 px-2 py-1 rounded text-sm"
                            target="_blank"
                          >
                            privatter
                          </a>
                        </li>
                      )}
                      {userProfile.link.other && (
                        <li>
                          <a
                            href="#"
                            className="text-white bg-indigo-400 transition-all hover:bg-indigo-700 px-2 py-1 rounded text-sm"
                            target="_blank"
                          >
                            {t_UserPage("other")}
                          </a>
                        </li>
                      )}
                    </ul>
                  )}
                </div>
              </div>

              {/* SP */}
              <h3 className="text-xl font-semibold my-4 md:hidden">
                ユーザー名
              </h3>

              {/* profile */}
              <Users.Profile profileText={userProfile.profile} />
            </div>
          </div>
        </section>
      </article>

      {/* イラスト一覧 */}
      <article>
        <section id="tabs" className="mx-2 md:container md:m-auto md:mb-8">
          <Users.UserTabs />
        </section>
        <section className="container my-2 m-auto">
          <div className="grid grid-cols-2 md:mx-auto md:grid-cols-4 mx-2 gap-1">
            {illusts.map((illust: IndexIllustData) => (
              <div key={illust.id}>
                <Illust illust={illust} />
              </div>
            ))}
          </div>
        </section>
        <section className="mt-4 mb-16">
          <UI.Pagination elementName="#tabs" adjust={-20} />
        </section>
      </article>
    </>
  );
}

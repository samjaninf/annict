# frozen_string_literal: true

ObjectTypes::Work = GraphQL::ObjectType.define do
  name "Work"
  description "An anime title"

  implements GraphQL::Relay::Node.interface

  global_id_field :id

  field :annictId, !types.Int do
    resolve ->(obj, _args, _ctx) {
      obj.id
    }
  end

  connection :episodes, ObjectTypes::Episode.connection_type do
    argument :orderBy, InputObjectTypes::EpisodeOrder

    resolve Resolvers::Episodes.new
  end

  field :title, !types.String
  field :titleKana, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.title_kana
    }
  end
  field :titleRo, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.title_ro
    }
  end
  field :titleEn, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.title_en
    }
  end

  field :media, !EnumTypes::Media do
    resolve ->(obj, _args, _ctx) {
      obj.media.upcase
    }
  end

  field :seasonYear, types.Int do
    resolve ->(obj, _args, _ctx) {
      obj.season_year
    }
  end
  field :seasonName, EnumTypes::SeasonName do
    resolve ->(obj, _args, _ctx) {
      obj.season_name&.upcase
    }
  end

  field :officialSiteUrl, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.official_site_url
    }
  end
  field :officialSiteUrlEn, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.official_site_url_en
    }
  end

  field :wikipediaUrl, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.wikipedia_url
    }
  end
  field :wikipediaUrlEn, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.wikipedia_url_en
    }
  end

  field :twitterUsername, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.twitter_username
    }
  end
  field :twitterHashtag, types.String do
    resolve ->(obj, _args, _ctx) {
      obj.twitter_hashtag
    }
  end

  field :image, ObjectTypes::WorkImage do
    resolve ->(obj, _args, _ctx) {
      ForeignKeyLoader.for(WorkImage, :work_id).load([obj.id])
    }
  end

  field :episodesCount, types.Int do
    resolve ->(obj, _args, _ctx) {
      obj.episodes_count
    }
  end
  field :watchersCount, types.Int do
    resolve ->(obj, _args, _ctx) {
      obj.watchers_count
    }
  end

  field :viewerStatusState, EnumTypes::StatusState do
    resolve ->(obj, _args, ctx) {
      state = ctx[:viewer].status_kind(obj)
      state == "no_select" ? "NO_STATE" : state.upcase
    }
  end
end

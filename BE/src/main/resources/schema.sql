drop table if exists event;
drop table if exists place;

create table event
(
    id          bigint          not null    auto_increment      comment '이벤트 PK',
    title       varchar(255)                                    comment '이벤트 제목',
    description varchar(255)                                    comment '이벤트 설명',
    image_url   varchar(1000)                                    comment '이벤트 이미지 URL',
    is_main     boolean         not null                        comment '메인이벤트 판단',
    primary key (id)
);


create table place
(
    id        bigint        not null        auto_increment      comment '여행지 PK',
    title     varchar(255)                                      comment '인기 여행지 이름',
    image_url varchar(1000)                                      comment '여행지 이미지 URL',
    lat       double                                            comment '인기 여행지 위도',
    lng       double                                            comment '인기 여행지 경도',
    primary key (id)
);

/*==============================================================*/
/* DBMS name:      fmy-admin                                    */
/* Created on:     2016/11/3 20:03:56                           */
/*==============================================================*/



drop table if exists SYS_APP;

drop table if exists SYS_PERMISSION;

drop table if exists SYS_RE_ROLE_PERMISSION;

drop table if exists SYS_RE_USER_APP;

drop table if exists SYS_RE_USER_ROLE;

drop table if exists SYS_ROLE;

drop table if exists SYS_USER;

/*==============================================================*/
/* Table: SYS_APP                                               */
/*==============================================================*/
create table SYS_APP
(
   id                   INT(20) not null auto_increment,
   name                 VARCHAR(300) not null comment '名称',
   code                 VARCHAR(100) not null comment '编码',
   sort                 INT(11) not null comment '排序',
   isEnable             BIT not null comment '是否启用',
   createTime           DATETIME not null comment '创建时间',
   create_user_id       INT(20) comment '创建人ID',
   last_change_timestamp DATETIME comment '修改时间',
   change_user_id       INT(20) comment '修改人ID',
   primary key (id)
);

alter table SYS_APP comment '系统应用';

/*==============================================================*/
/* Table: SYS_PERMISSION                                        */
/*==============================================================*/
create table SYS_PERMISSION
(
   id                   INT(20) not null auto_increment comment 'ID',
   appId                INT(20) not null comment '应用ID',
   parentId             INT(20) not null comment '父ID',
   name                 VARCHAR(300) not null comment '权限名称',
   code                 VARCHAR(100) not null comment '权限编号',
   icon                 VARCHAR(100) comment '图标',
   url                  VARCHAR(200) comment '权限URL',
   rela_url             VARCHAR(1000) comment '相关资源，使用分隔符分隔的资源URL',
   sort                 INT(11) not null comment '顺序号',
   path_menu            BIT not null comment '路径菜单没有对应的功能页面1：不是；2：是',
   isMenu               BIT not null comment '是否菜单',
   isEnable             BIT not null comment '是否启用',
   remark               VARCHAR(1000) comment '备注说明',
   create_timestamp     DATETIME comment '创建时间',
   create_user_id       INT(20) comment '创建人ID',
   last_change_timestamp DATETIME comment '修改时间',
   change_user_id       INT(20) comment '修改人ID',
   primary key (id)
);

alter table SYS_PERMISSION comment '系统权限';

/*==============================================================*/
/* Table: SYS_RE_ROLE_PERMISSION                                */
/*==============================================================*/
create table SYS_RE_ROLE_PERMISSION
(
   id                   INT(20) not null auto_increment,
   roleId               INT(20) not null comment '角色ID',
   permissionId         INT(20) not null comment '权限ID',
   appId                INT(20) not null comment '应用ID',
   primary key (id)
);

alter table SYS_RE_ROLE_PERMISSION comment '角色权限表';

/*==============================================================*/
/* Table: SYS_RE_USER_APP                                       */
/*==============================================================*/
create table SYS_RE_USER_APP
(
   id                   INT(20) not null auto_increment,
   userId               INT(20) not null comment '用户ID ',
   appId                INT(20) not null comment '应用ID',
   primary key (id)
);

alter table SYS_RE_USER_APP comment '用户应用表';

/*==============================================================*/
/* Table: SYS_RE_USER_ROLE                                      */
/*==============================================================*/
create table SYS_RE_USER_ROLE
(
   id                   INT(20) not null auto_increment comment 'ID',
   userId               INT(20) not null comment '用户ID ',
   roleId               INT(20) not null comment '角色ID',
   appId                INT(20) not null comment '应用ID',
   primary key (id)
);

alter table SYS_RE_USER_ROLE comment '用户角色表';

/*==============================================================*/
/* Table: SYS_ROLE                                              */
/*==============================================================*/
create table SYS_ROLE
(
   id                   INT(20) not null auto_increment comment 'ID',
   appId                INT(20) not null comment '应用ID',
   name                 VARCHAR(300) not null comment '名称',
   sort                 INT(11) not null comment '排序',
   description          VARCHAR(1000) comment '描述',
   issys                BIT default 0 comment '系统内置',
   isEnable             BIT not null comment '是否启用',
   create_timestamp     DATETIME comment '创建时间',
   create_user_id       INT(20) comment '创建人ID',
   last_change_timestamp DATETIME comment '修改时间',
   change_user_id       INT(20) comment '修改人ID',
   primary key (id)
);

alter table SYS_ROLE comment '角色';

/*==============================================================*/
/* Table: SYS_USER                                              */
/*==============================================================*/
create table SYS_USER
(
   id                   INT(20) not null auto_increment comment 'ID',
   job_no               VARCHAR(100) not null comment '用户工号',
   account              VARCHAR(100) not null comment '登录名',
   password             varchar(100) not null comment '密码(加密)',
   org_id               INT(20) comment '所在组织ID',
   user_name            VARCHAR(100) not null comment '用户姓名',
   gender               TINYINT comment '性别：1=男；2=女',
   email                VARCHAR(100) not null comment '电子邮箱',
   cell_phone           VARCHAR(100) not null comment '手机号码',
   address              VARCHAR(500) comment '联系地址',
   user_type            TINYINT comment '用户类型(暂时不需要使用该字段，作为保留字段)',
   issys                BIT not null comment '系统内置',
   lastLoginIp          VARCHAR(100) comment '最后登录IP',
   lastLoginTime        DATETIME comment '最后登录时间',
   loginCount           INT(11) not null default 0 comment '登录总次数',
   isEnable             BIT not null default 1 comment '是否启用',
   create_timestamp     DATETIME comment '创建时间',
   create_user_id       INT(20) comment '创建人ID',
   last_change_timestamp DATETIME comment '修改时间',
   change_user_id       INT(20) comment '修改人ID',
   primary key (id)
);

alter table SYS_USER comment '系统用户';

alter table SYS_PERMISSION add constraint FK_SYS_PERM_REFERENCE_SYS_APP foreign key (appId)
      references SYS_APP (id) on delete restrict on update restrict;

alter table SYS_RE_ROLE_PERMISSION add constraint FK_SYS_RE_R_REFERENCE_SYS_PERM foreign key (permissionId)
      references SYS_PERMISSION (id) on delete restrict on update restrict;

alter table SYS_RE_ROLE_PERMISSION add constraint FK_SYS_RE_R_REFERENCE_SYS_ROLE foreign key (roleId)
      references SYS_ROLE (id) on delete restrict on update restrict;

alter table SYS_RE_ROLE_PERMISSION add constraint FK_Reference_9 foreign key (appId)
      references SYS_APP (id) on delete restrict on update restrict;

alter table SYS_RE_USER_APP add constraint FK_Reference_10 foreign key (appId)
      references SYS_APP (id) on delete restrict on update restrict;

alter table SYS_RE_USER_APP add constraint FK_Reference_11 foreign key (userId)
      references SYS_USER (id) on delete restrict on update restrict;

alter table SYS_RE_USER_ROLE add constraint FK_SYS_RE_U_REFERENCE_SYS_USER foreign key (userId)
      references SYS_USER (id) on delete restrict on update restrict;

alter table SYS_RE_USER_ROLE add constraint FK_SYS_RE_U_REFERENCE_SYS_ROLE foreign key (roleId)
      references SYS_ROLE (id) on delete restrict on update restrict;

alter table SYS_RE_USER_ROLE add constraint FK_Reference_8 foreign key (appId)
      references SYS_APP (id) on delete restrict on update restrict;

alter table SYS_ROLE add constraint FK_SYS_ROLE_REFERENCE_SYS_APP foreign key (appId)
      references SYS_APP (id) on delete restrict on update restrict;
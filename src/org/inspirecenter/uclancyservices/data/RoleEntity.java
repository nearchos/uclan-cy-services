package org.inspirecenter.uclancyservices.data;

import com.google.appengine.api.datastore.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import java.util.logging.Logger;

public class RoleEntity {

    private static final Logger log = Logger.getLogger(UserEntity.class.getCanonicalName());

    public static final String KIND = "RoleEntity";

    public static final String PROPERTY_KEYWORD     = "keyword";
    public static final String PROPERTY_DESCRIPTION = "description";
    public static final String PROPERTY_CREATED_BY  = "created_by";
    public static final String PROPERTY_CREATED_ON  = "created_on";

    private String keyword;
    private String description;
    private String createdBy; // UserEntity's email
    private long createdOn;

    public RoleEntity(final String keyword, final String description, final String createdBy, final long createdOn) {
        this.keyword = keyword;
        this.description = description;
        this.createdBy = createdBy;
        this.createdOn = createdOn;
    }

    private RoleEntity(final Entity entity) {
        if(!KIND.equals(entity.getKind())) {
            throw new IllegalArgumentException("Entity must be of kind: " + KIND + " (found: " + entity.getKind() + ")");
        }

        this.keyword = (String) entity.getProperty(PROPERTY_KEYWORD);
        this.description = (String) entity.getProperty(PROPERTY_DESCRIPTION);
        this.createdBy = (String) entity.getProperty(PROPERTY_CREATED_BY);
        this.createdOn = (Long) entity.getProperty(PROPERTY_CREATED_ON);
    }

    public String getKeyword() {
        return keyword;
    }

    public String getDescription() {
        return description;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public long getCreatedOn() {
        return createdOn;
    }

    public String getCreatedOnAsFormattedString() {
        return new SimpleDateFormat("yyyy-MM-dd hh-mm").format(new Date(createdOn));
    }

    static public Vector<RoleEntity> getAllRoleEntities() {
        final DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();
        final Query query = new Query(KIND);
        final PreparedQuery preparedQuery = datastoreService.prepare(query);
        final List<Entity> entities = preparedQuery.asList(FetchOptions.Builder.withDefaults());

        final Vector<RoleEntity> roleEntities = new Vector<>();
        for(final Entity entity : entities) {
            roleEntities.add(new RoleEntity(entity));
        }
        return roleEntities;
    }

    static public Vector<String> getAllRoleKeywords() {
        final Vector<RoleEntity> allRoleEntities = getAllRoleEntities();
        final Vector<String> allRoles = new Vector<>();
        for(final RoleEntity roleEntity : allRoleEntities) {
            allRoles.add(roleEntity.getKeyword());
        }
        return allRoles;
    }

    static private Entity getRoleEntityByKeyword(final String keyword) {
        final DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();
        final Query query = new Query(KIND).setFilter(new Query.FilterPredicate(PROPERTY_KEYWORD, Query.FilterOperator.EQUAL, keyword));
        final PreparedQuery preparedQuery = datastoreService.prepare(query);
        final List<Entity> entities = preparedQuery.asList(FetchOptions.Builder.withDefaults());

        final Entity roleEntity;
        if(entities.size() == 0) {
            log.info("Could not find entity with " + PROPERTY_KEYWORD + ": " + keyword);
            return null;
        } else if(entities.size() == 1) {
            roleEntity= entities.get(0);
        } else {
            log.severe("More than 1 entities for : " + PROPERTY_KEYWORD + ": " + keyword);
            roleEntity= entities.get(0);
        }

        return roleEntity;
    }

    static public String addRoleEntity(final String keyword, final String description, final String createdBy) {

        if(getRoleEntityByKeyword(keyword) != null) {
            return "Error: entity with keyword '" + keyword + "' already exists";
        } else {
            final Entity roleEntity = new Entity(KIND);
            roleEntity.setProperty(PROPERTY_KEYWORD, keyword);
            roleEntity.setProperty(PROPERTY_DESCRIPTION, description);
            roleEntity.setProperty(PROPERTY_CREATED_BY, createdBy);
            roleEntity.setProperty(PROPERTY_CREATED_ON, System.currentTimeMillis());
            DatastoreServiceFactory.getDatastoreService().put(roleEntity);
            return "";
        }
    }
}
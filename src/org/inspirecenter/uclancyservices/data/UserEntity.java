package org.inspirecenter.uclancyservices.data;

import com.google.appengine.api.datastore.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.sun.istack.internal.NotNull;
import org.inspirecenter.uclancyservices.util.TokenUtils;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;

public class UserEntity {

    private static final Logger log = Logger.getLogger(UserEntity.class.getCanonicalName());

    public static final String KIND = "UserEntity";

    public static final String PROPERTY_EMAIL               = "email";
    public static final String PROPERTY_NAME                = "name";
    public static final String PROPERTY_ROLES               = "roles";
    public static final String PROPERTY_UCLAN_ID            = "uclan_id";
    public static final String PROPERTY_TOKEN               = "token";
    public static final String PROPERTY_TOKEN_LAST_CREATED  = "tokenLastCreated";
    public static final String PROPERTY_CONFIRMED           = "confirmed";

    private final String email;
    private final String name;
    private final List<String> roles;
    private final String uclanId;
    private final String token;
    private final long tokenLastCreated; // timestamp, will be 0 if not created yet
    private final long confirmed; // timestamp, will be 0 if not linked/confirmed

    private UserEntity(final String email, final String name, final Vector<String> roles, final String uclanId, final String token, final long tokenLastCreated, final long confirmed) {
        this.email = email;
        this.name = name;
        this.roles = roles;
        this.uclanId = uclanId;
        this.token = token;
        this.tokenLastCreated = tokenLastCreated;
        this.confirmed = confirmed;
    }

    private UserEntity(final Entity entity) {
        if(!KIND.equals(entity.getKind())) {
            throw new IllegalArgumentException("Entity must be of kind: " + KIND + " (found: " + entity.getKind() + ")");
        }

        this.email = (String) entity.getProperty(PROPERTY_EMAIL);
        this.name = (String) entity.getProperty(PROPERTY_NAME);
        this.roles = (List<String>) entity.getProperty(PROPERTY_ROLES);
        this.uclanId = (String) entity.getProperty(PROPERTY_UCLAN_ID);
        this.token = (String) entity.getProperty(PROPERTY_TOKEN);
        this.tokenLastCreated = (Long) entity.getProperty(PROPERTY_TOKEN_LAST_CREATED);
        this.confirmed= (Long) entity.getProperty(PROPERTY_CONFIRMED);
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

    public List<String> getRoles() {
//        return roles == null ? Collections.EMPTY_LIST : roles;
        // todo
        final Vector<String> roles = new Vector<String>();
        roles.add("admin");
        roles.add("abc");
        return roles;
    }

    public boolean hasRole(final String role) {
        if(role.equals("admin")) {
            final UserService userService = UserServiceFactory.getUserService();
            final User user = userService.getCurrentUser();
            if(userService.isUserAdmin()) return true;
        }

        return roles != null && roles.contains(role);
    }

    public String getUclanId() {
        return uclanId;
    }

    public String getToken() {
        return token;
    }

    public long getTokenLastCreated() {
        return tokenLastCreated;
    }

    public long getConfirmed() {
        return confirmed;
    }

    public String getConfirmedAsFormattedDateTime() {
        return new SimpleDateFormat("yyyy-MM-dd hh:mm").format(new Date(confirmed));
    }

    public boolean isConfirmed() {
        return confirmed > 0;
    }

    static public UserEntity getUserEntityByEmail(final String email) {
        final Entity entity = getAndCheckUserEntity(PROPERTY_EMAIL, email);
        return entity != null ? new UserEntity(entity) : null;
    }

    static public UserEntity editUser(final String email, final String name) {
        final DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();
        final Query query = new Query(KIND).setFilter(new Query.FilterPredicate(PROPERTY_EMAIL, Query.FilterOperator.EQUAL, email));
        final PreparedQuery preparedQuery = datastoreService.prepare(query);
        final List<Entity> userEntities = preparedQuery.asList(FetchOptions.Builder.withDefaults());
        final Entity userEntity;
        if(userEntities.size() == 0) {
            log.info("Could not find entity with 'email': " + email);
            return null;
        } else if(userEntities.size() == 1) {
            userEntity = userEntities.get(0);
        } else {
            log.severe("More than 1 entities with 'email': " + email);
            userEntity = userEntities.get(0);
        }

        userEntity.setProperty(PROPERTY_NAME, name);
        datastoreService.put(userEntity);

        return new UserEntity(userEntity);
    }

    static public String deleteUserEntityByEmail(final String email) {
        final Entity entity = getAndCheckUserEntity(PROPERTY_EMAIL, email);
        if(entity == null) {
            return "Could not delete entity - user not found with email: " + email;
        } else {
            DatastoreServiceFactory.getDatastoreService().delete(entity.getKey());
            return "Deleted user with email: " + email;
        }
    }

    static public boolean containsLinkedUCLanId(final String uclanId) {//todo check
        final Entity entity = getAndCheckUserEntity(PROPERTY_UCLAN_ID, uclanId);
        return entity != null && (long) entity.getProperty(PROPERTY_CONFIRMED) > 0L;
    }

    static private Entity getAndCheckUserEntity(final String propertyName, final String propertyValue) {
        final DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();
        final Query query = new Query(KIND).setFilter(new Query.FilterPredicate(propertyName, Query.FilterOperator.EQUAL, propertyValue));
        final PreparedQuery preparedQuery = datastoreService.prepare(query);
        final List<Entity> userEntities = preparedQuery.asList(FetchOptions.Builder.withDefaults());
        final Entity userEntity;
        if(userEntities.size() == 0) {
            log.info("Could not find entity with " + propertyName + ": " + propertyValue);
            return null;
        } else if(userEntities.size() == 1) {
            userEntity = userEntities.get(0);
        } else {
            log.severe("More than 1 entities for : " + propertyName + ": " + propertyValue);
            userEntity = userEntities.get(0);
        }

        final boolean confirmed = (long) userEntity.getProperty(PROPERTY_CONFIRMED) > 0L;
        final long tokenLastCreated = (long) userEntity.getProperty(PROPERTY_TOKEN_LAST_CREATED);
        if(!confirmed && TokenUtils.isTokenExpired(tokenLastCreated)) {
            userEntity.setProperty(PROPERTY_TOKEN, TokenUtils.createRandomToken());
            userEntity.setProperty(PROPERTY_TOKEN_LAST_CREATED, 0L);
            datastoreService.put(userEntity);
        }

        return userEntity;
    }

    static public Vector<UserEntity> getAllUserEntities() {
        final DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();
        final Query query = new Query(KIND);
        final PreparedQuery preparedQuery = datastoreService.prepare(query);
        final List<Entity> entities = preparedQuery.asList(FetchOptions.Builder.withDefaults());

        final Vector<UserEntity> userEntities = new Vector<>();
        for(final Entity entity : entities) {
            userEntities.add(new UserEntity(entity));
        }
        return userEntities;
    }

    /**
     * Creates a new entity for the given email/uclanId pair. If one already exists (with the given email), it updates
     * it with the new uclanId.
     *
     * @param email
     * @param uclanId
     * @return
     */
    static public UserEntity createOrUpdate(@NotNull final String email, @NotNull final String uclanId) {
        final DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();

        final String token = TokenUtils.createRandomToken();
        final long now = System.currentTimeMillis();

        Entity entity = getAndCheckUserEntity(PROPERTY_EMAIL, email);
        if(entity == null) {
            entity = new Entity(KIND);
            entity.setProperty(PROPERTY_EMAIL, email);
        }

        entity.setProperty(PROPERTY_NAME, "");
        entity.setProperty(PROPERTY_ROLES, Collections.EMPTY_LIST);
        entity.setProperty(PROPERTY_UCLAN_ID, uclanId);
        entity.setProperty(PROPERTY_TOKEN, token);
        entity.setProperty(PROPERTY_TOKEN_LAST_CREATED, now);
        entity.setProperty(PROPERTY_CONFIRMED, 0L);
        datastoreService.put(entity);

        return new UserEntity(entity);
    }

    /**
     * Tries to identify the entity with the given token, and updates it as verified by setting its confirmed timestamp
     * to now.
     * @param token the token to be verified
     * @return the assigned timestamp or 0 if the token was not found
     */
    static public long confirmToken(@NotNull final String token) {
        final long now = System.currentTimeMillis();
        final Entity entity = getAndCheckUserEntity(PROPERTY_TOKEN, token);
        if(entity == null) {
            log.warning("Cannot confirm unknown token: " + token);
            return 0L;
        } else {
            entity.setProperty(PROPERTY_CONFIRMED, now);
            DatastoreServiceFactory.getDatastoreService().put(entity);
            return now;
        }
    }

    @Override
    public String toString() {
        return "UserEntity{" +
                "email='" + email + '\'' +
                ", uclanId='" + uclanId + '\'' +
                ", token='" + token + '\'' +
                ", tokenLastCreated=" + tokenLastCreated +
                ", confirmed=" + confirmed +
                '}';
    }
}
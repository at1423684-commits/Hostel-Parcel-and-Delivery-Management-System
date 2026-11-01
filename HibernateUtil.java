package com.hostel.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

/**
 * Centralized Hibernate SessionFactory Utility for Hibernate 6.x.
 * Project: Hostel Parcel and Delivery Management System
 */
public class HibernateUtil {

    private static StandardServiceRegistry registry;
    private static SessionFactory sessionFactory;

    static {
        try {
            // Create registry
            registry = new StandardServiceRegistryBuilder().configure("hibernate.cfg.xml").build();

            // Create MetadataSources
            MetadataSources sources = new MetadataSources(registry);

            // Create Metadata
            Metadata metadata = sources.getMetadataBuilder().build();

            // Create SessionFactory
            sessionFactory = metadata.getSessionFactoryBuilder().build();
        } catch (Throwable ex) {
            System.err.println("Initial SessionFactory creation failed: " + ex);
            if (registry != null) {
                StandardServiceRegistryBuilder.destroy(registry);
            }
            // Do not throw runtime exception to avoid breaking non-hibernate modules if DB isn't running yet
        }
    }

    /**
     * Returns the singleton Hibernate SessionFactory.
     *
     * @return SessionFactory
     */
    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                registry = new StandardServiceRegistryBuilder().configure("hibernate.cfg.xml").build();
                MetadataSources sources = new MetadataSources(registry);
                Metadata metadata = sources.getMetadataBuilder().build();
                sessionFactory = metadata.getSessionFactoryBuilder().build();
            } catch (Exception e) {
                System.err.println("Re-attempted SessionFactory build failed: " + e.getMessage());
            }
        }
        return sessionFactory;
    }

    /**
     * Closes the SessionFactory.
     */
    public static void shutdown() {
        if (registry != null) {
            StandardServiceRegistryBuilder.destroy(registry);
        }
    }
}

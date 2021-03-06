# lib/hyhull/models/structural_set.rb
# Object model for the hyhull structural_set
module Hyhull
  module Models
    module StructuralSet
      extend ActiveSupport::Concern
      
      included do      
        include Hyhull::ModelMethods
        include Hyhull::Models::Permissions
        include Hyhull::Models::StructuralSetAncestryBehaviour
        include Hyhull::Models::SetTreeBehaviour 

        after_initialize :apply_genre

        # This before_create order is important...
        before_create :set_rights_metadata, :apply_default_object_rights

        has_metadata name: "descMetadata", label: "MODS metadata", type: Hyhull::Datastream::ModsSet
        has_metadata name: "defaultObjectRights", label: "Default object rights", type: Hyhull::Datastream::DefaultObjectRights

        has_attributes :title, :description, :resource_status, :genre, :type_of_resource, :primary_display_url, :identifier, datastream: :descMetadata, multiple: false

        belongs_to :parent, property: :is_member_of, :class_name => "StructuralSet"
        belongs_to :apo, property: :is_governed_by, :class_name => "StructuralSet"

        has_many :children, property: :is_member_of, :class_name => "ActiveFedora::Base"
        has_many :apo_children, property: :is_governed_by, :class_name => "ActiveFedora::Base"

        validates :title, presence: true
        # The root set do not have structural_set parent...
        validates :parent, presence: true, unless: Proc.new { |d| d.id == "hull:rootSet" || d.id == "hull:rootQueueSet"  }

        # Allows nil because the the test above will check for presence
        validates_exclusion_of :parent_id, :in => lambda { |p| [p.id]}, :message => "cannot be a parent to itself", :allow_nil => true

        # Overidden the Hydra::AccessControls::Permissions#permissions= method to enable setting of permissions on a
        # non rightsMetadata ds
        # See Hyhull::Models::StructuralSet::Permissions for implementation of set_permissions
        def permissions=(params)
          self.set_permissions(params, "defaultObjectRights")
        end

        # Overidden the Hydra::AccessControls::Permissions#permissions method to enable get of permissions on a
        # non rightsMetadata ds
        # See Hyhull::Models::StructuralSet::Permissions for implementation of get_permissions
        def permissions
          self.get_permissions "defaultObjectRights"
        end

        # Override the Hyhull:ModelMethods
        # Adds metadata about the depositor to the asset
        # Most important behavior: This version will NOT set rightsMetadata based on user_id (this is handled by set_rightsMetadata)
        # @param [String, #user_key] depositor
        #
        def apply_depositor_metadata(depositor, depositor_email)
          prop_ds = self.datastreams["properties"]

          depositor_id = depositor.respond_to?(:user_key) ? depositor.user_key : depositor

          if prop_ds
            prop_ds.depositor = depositor_id unless prop_ds.nil?
            prop_ds.depositor_email = depositor_email unless prop_ds.nil?
          end
          
          return true
        end

        def apply_genre
          self.genre = "Structural set"
        end

        # All stuctural_sets at present get their rightsMetadata from hull-apo:structuralSet
        def set_rights_metadata
          admin_policy_obj = self.class.find("hull-apo:structuralSet")
          raise "Unable to find hull-apo:structuralSet" unless admin_policy_obj
          self.apo = admin_policy_obj
          apply_rights_metadata_from_apo
        end

      end

      module ClassMethods
        # tree functionality is serviced by Hyhull::Models::SetTreeBehaviour 
        def tree
          tree_root = build_tree("hull:rootSet", "info\\:fedora\\/hull-cModel\\:structuralSet")
        end
      end

      # Inherit the defaultObjectRights from the set's parent. 
      def apply_default_object_rights
        raise "Unable to find parent. Cannot apply defaultObjectRights" unless parent
        defaultRights = Hyhull::Datastream::DefaultObjectRights.new(self.inner_object, 'defaultObjectRights')
        Hydra::Datastream::RightsMetadata.from_xml(parent.datastreams["defaultObjectRights"].content, defaultRights)
        self.datastreams["defaultObjectRights"] = defaultRights if self.datastreams.has_key? "defaultObjectRights" 
      end

      # assert_content_model overidden to add UketdObject custom models
      def assert_content_model
        add_relationship(:has_model, "info:fedora/hydra-cModel:commonMetadata")
        super
      end  

    end 
  end
end

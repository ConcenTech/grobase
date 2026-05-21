export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      gateway_events: {
        Row: {
          code: string
          gateway_id: string
          id: number
          ingested_at: string
          inverter_id: string
          level: string
          message: string | null
          metadata: Json | null
          recorded_at: string
        }
        Insert: {
          code: string
          gateway_id: string
          id?: never
          ingested_at?: string
          inverter_id: string
          level: string
          message?: string | null
          metadata?: Json | null
          recorded_at: string
        }
        Update: {
          code?: string
          gateway_id?: string
          id?: never
          ingested_at?: string
          inverter_id?: string
          level?: string
          message?: string | null
          metadata?: Json | null
          recorded_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "gateway_events_gateway_id_fkey"
            columns: ["gateway_id"]
            isOneToOne: false
            referencedRelation: "gateways"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "gateway_events_gateway_id_fkey"
            columns: ["gateway_id"]
            isOneToOne: false
            referencedRelation: "gateways_safe"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "gateway_events_inverter_id_fkey"
            columns: ["inverter_id"]
            isOneToOne: false
            referencedRelation: "inverters"
            referencedColumns: ["id"]
          },
        ]
      }
      gateways: {
        Row: {
          created_at: string
          device_secret_hash: string | null
          firmware_version: string | null
          hardware_id: string
          id: string
          inverter_id: string | null
          last_seen_at: string | null
          provisioned_by: string | null
          retired_at: string | null
          status: string
        }
        Insert: {
          created_at?: string
          device_secret_hash?: string | null
          firmware_version?: string | null
          hardware_id: string
          id?: string
          inverter_id?: string | null
          last_seen_at?: string | null
          provisioned_by?: string | null
          retired_at?: string | null
          status?: string
        }
        Update: {
          created_at?: string
          device_secret_hash?: string | null
          firmware_version?: string | null
          hardware_id?: string
          id?: string
          inverter_id?: string | null
          last_seen_at?: string | null
          provisioned_by?: string | null
          retired_at?: string | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "gateways_inverter_id_fkey"
            columns: ["inverter_id"]
            isOneToOne: false
            referencedRelation: "inverters"
            referencedColumns: ["id"]
          },
        ]
      }
      inverter_invites: {
        Row: {
          accepted_at: string | null
          accepted_by: string | null
          created_at: string
          expires_at: string
          id: string
          inverter_id: string
          invited_by: string
          revoked_at: string | null
          role: string
          token: string
        }
        Insert: {
          accepted_at?: string | null
          accepted_by?: string | null
          created_at?: string
          expires_at: string
          id?: string
          inverter_id: string
          invited_by: string
          revoked_at?: string | null
          role?: string
          token: string
        }
        Update: {
          accepted_at?: string | null
          accepted_by?: string | null
          created_at?: string
          expires_at?: string
          id?: string
          inverter_id?: string
          invited_by?: string
          revoked_at?: string | null
          role?: string
          token?: string
        }
        Relationships: [
          {
            foreignKeyName: "inverter_invites_inverter_id_fkey"
            columns: ["inverter_id"]
            isOneToOne: false
            referencedRelation: "inverters"
            referencedColumns: ["id"]
          },
        ]
      }
      inverter_members: {
        Row: {
          created_at: string
          inverter_id: string
          role: string
          user_id: string
        }
        Insert: {
          created_at?: string
          inverter_id: string
          role: string
          user_id: string
        }
        Update: {
          created_at?: string
          inverter_id?: string
          role?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inverter_members_inverter_id_fkey"
            columns: ["inverter_id"]
            isOneToOne: false
            referencedRelation: "inverters"
            referencedColumns: ["id"]
          },
        ]
      }
      inverter_snapshots: {
        Row: {
          battery_charge_energy_today_kwh: number | null
          battery_charge_power_w: number | null
          battery_current_a: number | null
          battery_discharge_energy_today_kwh: number | null
          battery_discharge_power_w: number | null
          battery_soc_percent: number | null
          battery_voltage_v: number | null
          gateway_id: string | null
          grid_active_power_w: number | null
          grid_charge_power_w: number | null
          grid_current_a: number | null
          grid_export_energy_today_kwh: number | null
          grid_export_power_w: number | null
          grid_frequency_hz: number | null
          grid_import_energy_today_kwh: number | null
          grid_voltage_v: number | null
          home_load_power_w: number | null
          id: number
          ingested_at: string
          inverter_id: string
          recorded_at: string
          solar_energy_today_kwh: number | null
          solar_power_w: number | null
        }
        Insert: {
          battery_charge_energy_today_kwh?: number | null
          battery_charge_power_w?: number | null
          battery_current_a?: number | null
          battery_discharge_energy_today_kwh?: number | null
          battery_discharge_power_w?: number | null
          battery_soc_percent?: number | null
          battery_voltage_v?: number | null
          gateway_id?: string | null
          grid_active_power_w?: number | null
          grid_charge_power_w?: number | null
          grid_current_a?: number | null
          grid_export_energy_today_kwh?: number | null
          grid_export_power_w?: number | null
          grid_frequency_hz?: number | null
          grid_import_energy_today_kwh?: number | null
          grid_voltage_v?: number | null
          home_load_power_w?: number | null
          id?: never
          ingested_at?: string
          inverter_id: string
          recorded_at: string
          solar_energy_today_kwh?: number | null
          solar_power_w?: number | null
        }
        Update: {
          battery_charge_energy_today_kwh?: number | null
          battery_charge_power_w?: number | null
          battery_current_a?: number | null
          battery_discharge_energy_today_kwh?: number | null
          battery_discharge_power_w?: number | null
          battery_soc_percent?: number | null
          battery_voltage_v?: number | null
          gateway_id?: string | null
          grid_active_power_w?: number | null
          grid_charge_power_w?: number | null
          grid_current_a?: number | null
          grid_export_energy_today_kwh?: number | null
          grid_export_power_w?: number | null
          grid_frequency_hz?: number | null
          grid_import_energy_today_kwh?: number | null
          grid_voltage_v?: number | null
          home_load_power_w?: number | null
          id?: never
          ingested_at?: string
          inverter_id?: string
          recorded_at?: string
          solar_energy_today_kwh?: number | null
          solar_power_w?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inverter_snapshots_gateway_id_fkey"
            columns: ["gateway_id"]
            isOneToOne: false
            referencedRelation: "gateways"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inverter_snapshots_gateway_id_fkey"
            columns: ["gateway_id"]
            isOneToOne: false
            referencedRelation: "gateways_safe"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inverter_snapshots_inverter_id_fkey"
            columns: ["inverter_id"]
            isOneToOne: false
            referencedRelation: "inverters"
            referencedColumns: ["id"]
          },
        ]
      }
      inverters: {
        Row: {
          created_at: string
          display_name: string | null
          id: string
          inverter_sn: string
          last_seen_at: string | null
          profile: string
        }
        Insert: {
          created_at?: string
          display_name?: string | null
          id?: string
          inverter_sn: string
          last_seen_at?: string | null
          profile: string
        }
        Update: {
          created_at?: string
          display_name?: string | null
          id?: string
          inverter_sn?: string
          last_seen_at?: string | null
          profile?: string
        }
        Relationships: []
      }
    }
    Views: {
      gateways_safe: {
        Row: {
          created_at: string | null
          firmware_version: string | null
          hardware_id: string | null
          id: string | null
          inverter_id: string | null
          last_seen_at: string | null
          provisioned_by: string | null
          retired_at: string | null
          status: string | null
        }
        Insert: {
          created_at?: string | null
          firmware_version?: string | null
          hardware_id?: string | null
          id?: string | null
          inverter_id?: string | null
          last_seen_at?: string | null
          provisioned_by?: string | null
          retired_at?: string | null
          status?: string | null
        }
        Update: {
          created_at?: string | null
          firmware_version?: string | null
          hardware_id?: string | null
          id?: string | null
          inverter_id?: string | null
          last_seen_at?: string | null
          provisioned_by?: string | null
          retired_at?: string | null
          status?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "gateways_inverter_id_fkey"
            columns: ["inverter_id"]
            isOneToOne: false
            referencedRelation: "inverters"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      get_gateways_safe: {
        Args: never
        Returns: {
          created_at: string
          firmware_version: string
          hardware_id: string
          id: string
          inverter_id: string
          last_seen_at: string
          provisioned_by: string
          retired_at: string
          status: string
        }[]
      }
      is_inverter_member: { Args: { p_inverter_id: string }; Returns: boolean }
      is_inverter_owner: { Args: { p_inverter_id: string }; Returns: boolean }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const

